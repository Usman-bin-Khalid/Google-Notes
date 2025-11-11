import 'package:flutter/material.dart';
import 'package:google_notes/views/screens/keep_clone_screen.dart';

class HelpApp extends StatelessWidget {
  const HelpApp({super.key});

  // Define the custom background color
  static const Color customBackgroundColor = Color(0xffffe9db);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Set the primary background color for the entire app
        scaffoldBackgroundColor: customBackgroundColor,
        primaryColor: customBackgroundColor,

        // App Bar styling
        appBarTheme: const AppBarTheme(
          color:
              customBackgroundColor, // Use the custom color for the AppBar background
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),

        // List Tile styling for clean look
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        useMaterial3: true,
      ),
      home: const HelpScreen(),
    );
  }
}

// --- HELP SCREEN WIDGET ---
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  // Dummy content for the expansion tiles (5-10 lines each)
  final String _privacyNoticeAnswer =
      """The Google Workspace Labs Privacy Notice outlines how your data is handled when participating in experimental features. This includes the collection and analysis of feedback, usage data, and interactions within the test environment. Data is primarily used for feature refinement, bug fixing, and improving the overall user experience. Importantly, personal identifying information is aggregated and anonymized wherever possible to protect your privacy. You retain control over your data, and participation is entirely voluntary, governed by separate terms from standard Workspace accounts. Review the full notice to understand data retention and deletion policies fully.""";

  final String _getStartedAnswer =
      """To begin using Google Workspace Labs, first ensure your account is eligible based on the current program requirements. Navigate to the Settings menu within your primary Workspace application (like Docs or Gmail) and look for the 'Labs' or 'Experimental Features' section. Here, you can view a list of available features to test. Simply toggle the feature on, and a guided tour or explanatory prompt will usually appear. Remember that Labs features are often unstable or incomplete, so expect occasional issues. Provide feedback directly through the in-app feedback mechanisms to help shape the final product and report any critical bugs encountered.""";

  final String _searchNotesAnswer =
      """Searching efficiently for notes and lists involves more than just typing keywords. Utilize advanced search filters available in your note application. You can filter by color (e.g., 'color:red'), label (e.g., 'label:recipes'), or even by the type of content, such as lists or notes with images. Use exact phrase matching by enclosing your query in quotation marks. For highly specific searches, combine multiple filters. For instance, 'label:work color:yellow "meeting notes"' will narrow down your results significantly. Remember to check your 'Archive' and 'Trash' folders, as the main search typically indexes all locations unless specified otherwise.""";

  final String _organizeNotesAnswer =
      """Effective note organization is crucial for productivity. Start by utilizing labels—these function like tags, allowing a single note to belong to multiple categories without duplication. Pin your most critical and frequently accessed notes to the top of your main screen for quick access. For completed or less-urgent items, use the archive feature instead of outright deletion; this keeps your main view clean while retaining the data. Routinely review your label structure to ensure it still reflects your current workflow. Consistent use of a few core labels is generally more effective than creating dozens of hyper-specific ones.""";

  final String _useKeepAnswer =
      """Integrating Google Keep notes directly into a Google Document or Presentation streamlines your workflow. When inside Docs or Slides, look for the 'Keep' icon, typically located on the right-hand sidebar. Clicking this will open your full list of Keep notes. You can drag and drop any note directly into your document. The contents of the note—including text, images, and lists—will be inserted at your cursor location. This is especially useful for quickly moving research snippets or presentation talking points. Any changes made to the original note in the Keep app will be reflected if you re-insert or refresh the document sidebar.""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- App Bar ---
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KeepCloneScreen()),
            );
          },
        ),
        title: const Text('Help'),
        centerTitle: false,
        actions: const [Icon(Icons.more_vert), SizedBox(width: 8)],
      ),
      // --- Body Content ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Popular help resources Section ---
            const Padding(
              padding: EdgeInsets.fromLTRB(
                16.0,
                32.0,
                16.0,
                12.0,
              ), // Increased top padding
              child: Text(
                'Popular help resources',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold for emphasis
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),

            // Expansion Tiles wrapped in a Container for unified background
            Card(
              color: Colors.white,
              child: Container(
                color: Colors.white, // White background for the list block
                child: Column(
                  children: [
                    _HelpExpansionTile(
                      title:
                          'Google Workspace Labs Privacy Notice and Terms for Personal Accounts',
                      answer: _privacyNoticeAnswer,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _HelpExpansionTile(
                      title: 'Get started with Google Workspace Labs',
                      answer: _getStartedAnswer,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _HelpExpansionTile(
                      title: 'Search for notes & lists',
                      answer: _searchNotesAnswer,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _HelpExpansionTile(
                      title: 'Organise your notes',
                      answer: _organizeNotesAnswer,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _HelpExpansionTile(
                      title: 'Use Google Keep in a document or presentation',
                      answer: _useKeepAnswer,
                    ),
                  ],
                ),
              ),
            ),

            // --- Search Help Input ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 32.0,
              ), // Increased vertical padding
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the search bar
                  borderRadius: BorderRadius.circular(32.0), // More rounded
                  border: Border.all(color: Colors.black12, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // subtle shadow
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.black54),
                    SizedBox(width: 12.0),
                    Text(
                      'Search help',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // --- Need more help? Section ---
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
              child: Text(
                'Need more help?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),

            // Post to the Help Community Card
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Card(
                color: Colors.white, // White card background
                elevation: 3, // Increased elevation for a floating look
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ), // More rounded corners
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(
                      10,
                    ), // Larger padding for a more distinct circle
                    decoration: BoxDecoration(
                      color: Colors
                          .blue
                          .shade600, // Retaining the blue for brand consistency
                      shape: BoxShape.circle, // Circular background
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    'Post to the Help Community',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  subtitle: const Text(
                    'Get answers from community members',
                    style: TextStyle(color: Colors.black54),
                  ),
                  onTap: () {},
                ),
              ),
            ),

            // Send Feedback ListTile (Styled to match the new padding and font)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ), // Adjusted padding
              leading: const Icon(Icons.book_outlined, color: Colors.black87),
              title: const Text(
                'Send Feedback',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
              ),
              onTap: () {},
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// --- Custom ExpansionTile Widget ---
class _HelpExpansionTile extends StatelessWidget {
  final String title;
  final String answer;

  const _HelpExpansionTile({required this.title, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor:
            Colors.transparent, // Remove the internal divider of ExpansionTile
        listTileTheme: const ListTileThemeData(
          minLeadingWidth: 32, // Adjust space for leading icon
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ), // Adjusted padding
        leading: const Icon(
          Icons.description_outlined,
          color: Colors.black87,
        ), // Icon style
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        // Remove the default arrow color tint
        iconColor: Colors.black54,
        collapsedIconColor: Colors.black54,

        children: <Widget>[
          Padding(
            // Aligned content to be under the title and body
            padding: const EdgeInsets.fromLTRB(68.0, 0, 16.0, 16.0),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
