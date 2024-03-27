import 'package:flutter/material.dart';
import 'package:login_signup/theme/theme.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Dermalyse',
    theme: ThemeData(
        primarySwatch: Colors.blue,
),
    home: TreatmentPage(), // Replace with your app's home widget
  ));
}

class TreatmentPage extends StatefulWidget {
  const TreatmentPage({super.key});

  @override
  State<TreatmentPage> createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        title: const Text(
          'DERMALYSE',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: BackButton(
          onPressed: ()=>Navigator.of(context).pop(),
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 65),
                ),
                ElevatedButton(
                    onPressed: (){},
                    child: const Text('ABOVE 18',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightColorScheme.primary,
                       // maximumSize: Size(0,0)


                    ),
                ),
                SizedBox(width: 25),
                ElevatedButton(
                  onPressed: (){},
                  child: Text('BELOW 18',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: lightColorScheme.primary
                  ),
                ),
              ],
            ),
            Container(
              height: 150,
              width: 375,
              margin:  const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.blueAccent,
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0,
                    vertical: 20,
                  ),
                  child: Text(
                    'Atopic dermatitis (ICD-10: L20.8)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin:
              const EdgeInsets.symmetric(horizontal: 20,
                  vertical: 0),
              // const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.black,
              //     width: 3,
              //   ),
              //   borderRadius: BorderRadius.circular(20).copyWith(
              //     topLeft: Radius.zero,
              //   ),
              // ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    'Anime, a vibrant tapestry woven from animation, storytelling, and artistic expression, has captivated audiences worldwide. Beyond the realm of mere cartoons, anime offers a unique blend of genres, captivating narratives, and stunning visuals that have transcended cultural boundaries. This essay delves into the world of anime, exploring its history, diverse genres, and the reasons behind its global appeal.Born in Japan, anime traces its roots back to the early 20th century, drawing inspiration from Western animation and traditional Japanese artistic styles like woodblock prints. As the medium matured, it developed its own distinct aesthetic, characterized by expressive characters with large eyes, dynamic action sequences, and a rich emotional depth. Over the decades, anime has blossomed into a vast and diverse landscape, encompassing a spectrum of genres – from the heart-pounding thrills of shounen action to the introspective themes explored in slice-of-life stories. One of the defining aspects of anime is its ability to cater to a wide range of audiences. From the lighthearted adventures of magical girls in shoujo anime to the complex philosophical questions posed in seinen works aimed at adults, theres something for everyone. This diversity allows viewers to connect with stories that resonate with their interests, emotions, and life experiences.The storytelling in anime often goes beyond simple entertainment. Anime narratives can be layered and complex, exploring themes of love, loss, friendship, and societal issues. Characters are often multifaceted, grappling with internal struggles and overcoming seemingly insurmountable challenges. This depth of storytelling allows viewers to form strong emotional bonds with the characters, making them laugh, cry, and cheer alongside them on their journeys.Visually, anime is a feast for the eyes. Studios and artists employ a variety of animation techniques, from traditional cel animation to cutting-edge CGI, to bring stories to life. The visuals are often characterized by vibrant colors, stunning landscapes, and meticulously detailed character designs. This visual prowess serves not only as entertainment but also as a storytelling tool, conveying emotions and setting the tone for the narrative.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
