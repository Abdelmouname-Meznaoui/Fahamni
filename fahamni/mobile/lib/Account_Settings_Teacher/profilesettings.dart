import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'language_screen.dart';
import 'deleteacc_screen.dart';
import 'changepas_screen.dart'; 
import 'updateemailpass_screen.dart';
import 'updatephonepass_screen.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  Widget item(BuildContext context, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  height: 1.5,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF1F5F9),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.profileSettings,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
 
      body: Padding(
       padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 128, 0.30),
                blurRadius: 3,
                spreadRadius: 0,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              //  CHANGE PASSWORD
              item(context, localizations.changePassword, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              }),

              divider(),

              item(context, localizations.updateEmail, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdateEmailPasswordScreen(),
                  ),
                );
              }),

              divider(),

              item(context, localizations.updatePhoneNumber, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdatePhonePasswordScreen(),
                  ),
                );
              }),

              divider(),

              //  LANGUAGE
              item(context, localizations.language, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageScreen(),
                  ),
                );
              }),

              divider(),

              //  DELETE ACCOUNT
              item(context, localizations.deleteAccount, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeleteAccountScreen(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

