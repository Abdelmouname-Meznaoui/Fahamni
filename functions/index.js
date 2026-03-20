const { onCall, HttpsError } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
admin.initializeApp();

exports.resetPassword = onCall({ allowUnauthenticated: true }, async (request) => {
  // v2 uses request.data instead of just data
  const { email, newPassword } = request.data;

  if (!email || !newPassword) {
    throw new HttpsError("invalid-argument", "Missing fields.");
  }
  if (newPassword.length < 6) {
    throw new HttpsError("invalid-argument", "Password must be at least 6 characters.");
  }

  try {
    const user = await admin.auth().getUserByEmail(email);
    await admin.auth().updateUser(user.uid, { password: newPassword });
    return { success: true };
  } catch (e) {
    throw new HttpsError("internal", e.message);
  }
});