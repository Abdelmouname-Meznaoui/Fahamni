import { useState, useEffect } from "react";
import { collection, query, where, getDocs, updateDoc, doc, getCountFromServer } from "firebase/firestore";
import { db } from "./firebase";

const MONTHS = ["January","February","March","April","May","June",
                 "July","August","September","October","November","December"];

function formatDate(val) {
  if (!val) return "—";
  const d = val.toDate ? val.toDate() : new Date(val);
  if (isNaN(d)) return "—";
  return `${MONTHS[d.getMonth()]} ${d.getDate()}, ${d.getFullYear()}`;
}

function capitalize(str) {
  if (!str) return "—";
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function formatLevels(levels) {
  if (!levels?.length) return "—";
  return levels.map(l => l.replace(/_/g, " ").replace(/\b\w/g, c => c.toUpperCase())).join(", ");
}

const TABS = ["General Info", "Reports", "Services", "Feedbacks"];

export default function UserProfilePage({ user, onBack, onSuspendChange }) {
  const [activeTab, setActiveTab] = useState("General Info");
  const [certificates, setCertificates] = useState(null);
  const [stats, setStats] = useState({ students: null, rating: null, courses: null });
  const [suspended, setSuspended] = useState(user.is_suspended === true);
  const [saving, setSaving] = useState(false);

  const tutorUid = user.uid ?? user.id;
  const fullName = `${user.first_name ?? ""} ${user.last_name ?? ""}`.trim();

  useEffect(() => {
    if (!tutorUid) return;

    getDocs(query(collection(db, "resources"), where("tutor_id", "==", tutorUid)))
      .then(snap => setCertificates(snap.docs.map(d => ({ id: d.id, ...d.data() }))))
      .catch(() => setCertificates([]));

    Promise.all([
      getCountFromServer(query(collection(db, "sessions"), where("tutor_id", "==", tutorUid))),
      getCountFromServer(query(collection(db, "services"), where("tutor_id", "==", tutorUid))),
    ]).then(([sessSnap, svcSnap]) => {
      setStats({
        students: sessSnap.data().count,
        rating: user.average_rating ?? null,
        courses: svcSnap.data().count,
      });
    }).catch(() => {});
  }, [tutorUid]);

  async function toggleSuspend() {
    setSaving(true);
    const next = !suspended;
    try {
      await updateDoc(doc(db, "tutors", user.id), { is_suspended: next });
      setSuspended(next);
      onSuspendChange?.(user.id, next);
    } catch (e) {
      console.error(e);
    } finally {
      setSaving(false);
    }
  }

  return (
    <div style={s.page}>

      {/* ── Header ── */}
      <div style={s.header}>
        <div>
          <div style={s.breadcrumb}>
            <span style={s.breadLink} onClick={onBack}>Users</span>
            <span style={s.breadSep}>›</span>
            <span style={s.breadCurrent}>User Profile</span>
          </div>
          <h1 style={s.pageTitle}>User Profile</h1>
        </div>
        <div style={s.headerBtns}>
          <button style={s.contactBtn}>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2">
              <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
            </svg>
            Contact
          </button>
          <button
            style={{ ...s.suspendBtn, opacity: saving ? 0.6 : 1 }}
            disabled={saving}
            onClick={toggleSuspend}
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2">
              <circle cx="12" cy="12" r="10"/>
              <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/>
            </svg>
            {saving ? "Saving…" : suspended ? "Unsuspend Account" : "Suspend Account"}
          </button>
        </div>
      </div>

      {/* ── Body ── */}
      <div style={s.body}>

        {/* Left card */}
        <div style={s.leftCard}>
          <div style={s.statusBadge(suspended)}>
            {suspended ? "SUSPENDED" : "ACTIVE"}
          </div>

          {user.picture
            ? <img src={user.picture} alt="avatar" style={s.avatar} />
            : <div style={s.avatarFallback}>
                <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="1.4">
                  <circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
                </svg>
              </div>
          }

          <div style={s.name}>{fullName}</div>
          <span style={s.rolePill}>Teacher</span>

          <div style={s.contactRow}>
            <div style={s.contactIcon}>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" strokeWidth="2">
                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                <polyline points="22,6 12,13 2,6"/>
              </svg>
            </div>
            <div>
              <div style={s.contactLabel}>EMAIL ADDRESS</div>
              <div style={s.contactValue}>{user.email || "—"}</div>
            </div>
          </div>

          <div style={s.contactRow}>
            <div style={s.contactIcon}>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" strokeWidth="2">
                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.61 3.38 2 2 0 0 1 3.58 1.18h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.73a16 16 0 0 0 6 6l.92-.92a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 21.73 16l.19.92z"/>
              </svg>
            </div>
            <div>
              <div style={s.contactLabel}>PHONE NUMBER</div>
              <div style={s.contactValue}>{user.phone || "—"}</div>
            </div>
          </div>

          {user.pedagogical_description && (
            <div style={s.descSection}>
              <div style={s.descTitle}>Personal Description</div>
              <div style={s.descText}>{user.pedagogical_description}</div>
            </div>
          )}
        </div>

        {/* Right area */}
        <div style={s.right}>

          {/* Tabs */}
          <div style={s.tabsRow}>
            {TABS.map(t => (
              <button
                key={t}
                style={{ ...s.tab, ...(activeTab === t ? s.tabActive : {}) }}
                onClick={() => setActiveTab(t)}
              >
                {t}
              </button>
            ))}
          </div>

          {/* Tab content */}
          {activeTab === "General Info" && (
            <div style={s.tabContent}>

              {/* Main column */}
              <div style={s.mainCol}>

                {/* Detailed Information */}
                <div style={s.infoCard}>
                  <div style={s.cardHeader}>
                    <div style={s.infoIcon}>i</div>
                    <span style={s.cardTitle}>Detailed Information</span>
                  </div>
                  <div style={s.infoGrid}>
                    <Field label="FULL NAME"         value={fullName || "—"} />
                    <Field label="GENDER"            value={capitalize(user.gender)} />
                    <Field label="LEVEL"             value={formatLevels(user.levels_taught)} />
                    <Field label="EXPERTISE DOMAIN"  value={user.expertise_domain || "—"} />
                    <Field label="TEACHING MODE"     value={capitalize(user.teaching_mode)} />
                    <Field label="JOINED DATE"       value={formatDate(user.created_at)} />
                  </div>
                </div>

                {/* Academic Description */}
                {user.academic_description && (
                  <div style={s.descCard}>
                    <div style={s.cardTitle}>Academic Description</div>
                    <div style={s.descBody}>{user.academic_description}</div>
                  </div>
                )}

                {/* Certificates */}
                <div style={s.certCard}>
                  <div style={s.cardTitle}>Teacher Certificates</div>
                  <div style={s.certList}>
                    {certificates === null ? (
                      <span style={s.dimText}>Loading...</span>
                    ) : certificates.length === 0 ? (
                      <span style={s.dimText}>No certificates uploaded.</span>
                    ) : certificates.map(c => (
                      <div key={c.id} style={s.certItem}>
                        <div style={s.certIconWrap}>
                          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6366f1" strokeWidth="1.8">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                            <polyline points="14 2 14 8 20 8"/>
                          </svg>
                        </div>
                        <div>
                          <div style={{ fontSize: 12, fontWeight: 600, color: "#1F2937" }}>
                            {c.title || "Certificate.pdf"}
                          </div>
                          {c.size_mb && <div style={{ fontSize: 11, color: "#94a3b8" }}>{c.size_mb} MB</div>}
                        </div>
                        <button style={s.dlBtn} title="Download">
                          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" strokeWidth="2">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                            <polyline points="7 10 12 15 17 10"/>
                            <line x1="12" y1="15" x2="12" y2="3"/>
                          </svg>
                        </button>
                      </div>
                    ))}
                  </div>
                </div>

              </div>

              {/* Quick Stats column */}
              <div style={s.statsCard}>
                <div style={s.statsLabel}>QUICK STATS</div>
                <div style={s.statsTitle}>Teacher Profile</div>
                <div style={s.statRow}>
                  <span style={s.statKey}>Students</span>
                  <span style={s.statVal}>{stats.students === null ? "—" : stats.students.toLocaleString()}</span>
                </div>
                <div style={s.statRow}>
                  <span style={s.statKey}>Rating</span>
                  <span style={s.statVal}>
                    {stats.rating == null ? "—" : `${Number(stats.rating).toFixed(1)} / 5.0`}
                  </span>
                </div>
                <div style={s.statRow}>
                  <span style={s.statKey}>Courses</span>
                  <span style={s.statVal}>{stats.courses === null ? "—" : stats.courses}</span>
                </div>
              </div>

            </div>
          )}

          {activeTab !== "General Info" && (
            <div style={{ color: "#94a3b8", fontSize: 14, paddingTop: 40, textAlign: "center" }}>
              {activeTab} — coming soon.
            </div>
          )}

        </div>
      </div>
    </div>
  );
}

function Field({ label, value }) {
  return (
    <div>
      <div style={{ fontSize: 10, fontWeight: 700, color: "#94a3b8", letterSpacing: "0.06em", marginBottom: 4 }}>{label}</div>
      <div style={{ fontSize: 13, fontWeight: 600, color: "#1F2937" }}>{value}</div>
    </div>
  );
}

const s = {
  page: { display: "flex", flexDirection: "column", height: "100%", minHeight: 0, gap: 16 },

  header: {
    display: "flex", alignItems: "flex-start", justifyContent: "space-between", flexShrink: 0,
  },
  breadcrumb: { display: "flex", alignItems: "center", gap: 6, marginBottom: 4 },
  breadLink: { fontSize: 12, color: "#94a3b8", cursor: "pointer" },
  breadSep: { fontSize: 12, color: "#cbd5e1" },
  breadCurrent: { fontSize: 12, color: "#000080", fontWeight: 600 },
  pageTitle: { fontSize: 28, fontWeight: 800, color: "#1F2937", margin: 0 },

  headerBtns: { display: "flex", gap: 10, alignItems: "center", paddingTop: 14 },
  contactBtn: {
    display: "flex", alignItems: "center", gap: 8,
    padding: "10px 20px", borderRadius: 24, border: "none",
    background: "#22c55e", color: "#fff", fontSize: 14, fontWeight: 600, cursor: "pointer",
  },
  suspendBtn: {
    display: "flex", alignItems: "center", gap: 8,
    padding: "10px 20px", borderRadius: 24, border: "none",
    background: "#ef4444", color: "#fff", fontSize: 14, fontWeight: 600, cursor: "pointer",
  },

  body: { display: "flex", gap: 20, flex: 1, minHeight: 0, alignItems: "flex-start" },

  /* left card */
  leftCard: {
    width: 230, flexShrink: 0,
    background: "#fff", borderRadius: 16, border: "1px solid #f1f5f9",
    padding: "20px 18px", display: "flex", flexDirection: "column", alignItems: "center",
    boxShadow: "0 2px 8px rgba(0,0,0,0.04)",
  },
  statusBadge: (suspended) => ({
    alignSelf: "flex-end",
    fontSize: 11, fontWeight: 700, letterSpacing: "0.06em",
    color: suspended ? "#ef4444" : "#22c55e",
    background: suspended ? "#fef2f2" : "#f0fdf4",
    borderRadius: 6, padding: "3px 10px", marginBottom: 12,
  }),
  avatar: { width: 80, height: 80, borderRadius: "50%", objectFit: "cover", marginBottom: 12 },
  avatarFallback: {
    width: 80, height: 80, borderRadius: "50%", background: "#000080",
    display: "flex", alignItems: "center", justifyContent: "center", marginBottom: 12,
  },
  name: { fontSize: 16, fontWeight: 700, color: "#1F2937", textAlign: "center", marginBottom: 6 },
  rolePill: {
    fontSize: 11, fontWeight: 600, color: "#6366f1", background: "#eef2ff",
    borderRadius: 20, padding: "3px 14px", marginBottom: 18,
  },
  contactRow: { display: "flex", alignItems: "flex-start", gap: 10, width: "100%", marginBottom: 12 },
  contactIcon: {
    width: 30, height: 30, borderRadius: 8, background: "#f8fafc",
    border: "1px solid #e2e8f0", display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0,
  },
  contactLabel: { fontSize: 9, fontWeight: 700, color: "#94a3b8", letterSpacing: "0.06em", marginBottom: 2 },
  contactValue: { fontSize: 12, fontWeight: 600, color: "#1F2937" },
  descSection: { width: "100%", marginTop: 8 },
  descTitle: { fontSize: 12, fontWeight: 700, color: "#1F2937", marginBottom: 6 },
  descText: { fontSize: 12, color: "#64748b", lineHeight: 1.6 },

  /* right */
  right: { flex: 1, minWidth: 0, display: "flex", flexDirection: "column", gap: 14 },

  tabsRow: {
    display: "flex", background: "#fff", borderRadius: 12,
    border: "1px solid #f1f5f9", padding: 4, gap: 2, flexShrink: 0,
    boxShadow: "0 2px 8px rgba(0,0,0,0.04)", alignSelf: "flex-start",
  },
  tab: {
    padding: "8px 20px", borderRadius: 9, border: "none",
    background: "transparent", fontSize: 13, fontWeight: 500,
    color: "#64748b", cursor: "pointer",
  },
  tabActive: { background: "#000080", color: "#fff", fontWeight: 600 },

  tabContent: { display: "flex", gap: 16, flex: 1, minHeight: 0, alignItems: "flex-start" },

  mainCol: { flex: 1, minWidth: 0, display: "flex", flexDirection: "column", gap: 14 },

  infoCard: {
    background: "#fff", borderRadius: 14, border: "1px solid #f1f5f9",
    padding: "18px 20px", boxShadow: "0 2px 8px rgba(0,0,0,0.04)",
  },
  cardHeader: { display: "flex", alignItems: "center", gap: 8, marginBottom: 16 },
  infoIcon: {
    width: 22, height: 22, borderRadius: "50%", background: "#6366f1",
    color: "#fff", fontSize: 13, fontWeight: 700,
    display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0,
  },
  cardTitle: { fontSize: 14, fontWeight: 700, color: "#1F2937" },
  infoGrid: { display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px 32px" },

  descCard: {
    background: "#fff", borderRadius: 14, border: "1px solid #f1f5f9",
    padding: "16px 20px", boxShadow: "0 2px 8px rgba(0,0,0,0.04)",
  },
  descBody: { fontSize: 13, color: "#64748b", lineHeight: 1.7, marginTop: 10 },

  certCard: {
    background: "#fff", borderRadius: 14, border: "1px solid #f1f5f9",
    padding: "16px 20px", boxShadow: "0 2px 8px rgba(0,0,0,0.04)",
  },
  certList: { display: "flex", flexWrap: "wrap", gap: 10, marginTop: 12 },
  certItem: {
    display: "flex", alignItems: "center", gap: 10,
    background: "#f8fafc", borderRadius: 10, border: "1px solid #e2e8f0",
    padding: "10px 12px", width: 180,
  },
  certIconWrap: {
    width: 36, height: 36, borderRadius: 8, background: "#eef2ff",
    display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0,
  },
  dlBtn: {
    background: "none", border: "none", cursor: "pointer",
    marginLeft: "auto", padding: 4, display: "flex",
  },
  dimText: { fontSize: 13, color: "#94a3b8" },

  /* Quick Stats */
  statsCard: {
    width: 190, flexShrink: 0, background: "#000080", borderRadius: 14,
    padding: "20px 18px", color: "#fff",
  },
  statsLabel: { fontSize: 10, fontWeight: 700, color: "#93c5fd", letterSpacing: "0.08em", marginBottom: 6 },
  statsTitle: { fontSize: 20, fontWeight: 700, color: "#fff", marginBottom: 20, lineHeight: 1.3 },
  statRow: {
    display: "flex", alignItems: "center", justifyContent: "space-between",
    paddingBottom: 14, marginBottom: 14, borderBottom: "1px solid rgba(255,255,255,0.1)",
  },
  statKey: { fontSize: 13, color: "#93c5fd" },
  statVal: { fontSize: 18, fontWeight: 700, color: "#fff" },
};
