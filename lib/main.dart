import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: UserInputScreen(),
    );
  }
}

class UserInputScreen extends StatefulWidget {
  @override
  _UserInputScreenState createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  String? selectedPlatform;
  String generatedBio = "";
  bool isLoading = false;

  final List<String> socialMediaPlatforms = [
    "Instagram",
    "Twitter",
    "Facebook",
    "LinkedIn",
    "Snapchat"
  ];

  final Map<String, String> moodBasedBios = {
    "happy":
        "Hey, I'm {name}, a {profession}! My world is painted in bright colors, and I'm here to share the joy! 😃✨ Let's make memories on {platform}!",
    "sad":
        "Hey, I'm {name}, a {profession}. Some days are heavy, but kindness and music keep me afloat. 💙🌧 Stay close on {platform}.",
    "excited":
        "Hey, I'm {name}, a {profession}! Life’s a thrilling adventure, and I’m racing toward my dreams! 🎢🔥 Join the excitement on {platform}!",
    "chill":
        "Hey, I'm {name}, a {profession}. Floating through life like a lazy Sunday afternoon. 🍃🎶 Come vibe with me on {platform}!",
    "motivated":
        "Hey, I'm {name}, a {profession}! Eyes on the prize, heart full of fire, and nothing can stop me! 💪🚀 Follow my journey on {platform}!"
  };

  void generateBio() async {
    setState(() {
      isLoading = true;
    });

    // Simulate a delay for loading effect
    await Future.delayed(Duration(seconds: 1));

    String mood = _moodController.text.toLowerCase();
    String name = _nameController.text;
    String profession = _professionController.text;
    String platform = selectedPlatform ?? "";

    String bioTemplate = moodBasedBios.containsKey(mood)
        ? moodBasedBios[mood]!
        : "Hey, I'm {name}, a {profession}! Feeling {mood} and embracing the moment. 🌟 Stay connected on {platform}!";

    setState(() {
      generatedBio = bioTemplate
          .replaceAll("{name}", name)
          .replaceAll("{mood}", mood)
          .replaceAll("{profession}", profession)
          .replaceAll("{platform}", platform);
      isLoading = false;
    });
  }

  void clearFields() {
    setState(() {
      _nameController.clear();
      _moodController.clear();
      _professionController.clear();
      selectedPlatform = null;
      generatedBio = "";
    });
  }

  bool validateInputs() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter your name!"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (_moodController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please describe your mood!"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (_professionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter your profession!"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (selectedPlatform == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select a social media platform!"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  Widget buildInputField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.pink[300]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        prefixIcon: Icon(icon, color: Colors.pink[300]),
      ),
    );
  }

  Widget buildActionButton(
      String text, VoidCallback onPressed, Color color, IconData icon) {
    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        icon: isLoading && text == "Generate Bio"
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(icon, size: 20),
        label: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minimalist Bio Generator"),
        backgroundColor: Colors.pink[300],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/background.jpg"), // Add your image to assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent Layer
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          // Main Content
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: buildInputField(
                          _nameController, "Enter your name", Icons.person),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedPlatform,
                        decoration: InputDecoration(
                          labelText: "Social Media",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.pink[300]!, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          prefixIcon:
                              Icon(Icons.public, color: Colors.pink[300]),
                        ),
                        items: socialMediaPlatforms.map((platform) {
                          return DropdownMenuItem(
                            value: platform,
                            child: Text(platform),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPlatform = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                buildInputField(
                    _professionController, "Enter your profession", Icons.work),
                SizedBox(height: 20),
                buildInputField(
                    _moodController, "How are you feeling?", Icons.mood),
                SizedBox(height: 20),
                Row(
                  children: [
                    buildActionButton(
                      "Generate Bio",
                      () {
                        if (validateInputs()) {
                          generateBio();
                        }
                      },
                      Colors.pink[300]!,
                      Icons.create,
                    ),
                    SizedBox(width: 10),
                    buildActionButton(
                      "Clear",
                      clearFields,
                      Colors.grey[600]!,
                      Icons.clear,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (generatedBio.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.pink[300]!, width: 2),
                    ),
                    child: Text(
                      generatedBio,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[800],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
