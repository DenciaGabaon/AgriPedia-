import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'NavigationBar.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'CropData.dart';
import 'CropManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Supabase import
import 'package:supabase_flutter/supabase_flutter.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await Supabase.initialize(
    url: 'https://kaidorbevjarpoujjgqq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImthaWRvcmJldmphcnBvdWpqZ3FxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjEzODE0ODAsImV4cCI6MjAzNjk1NzQ4MH0.K_2JnJLDcZABX5CBtWYeLME5Gte9K4ldOoUkUhJshC0',
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CropDataManager()),
      ],
      child: const AgriPedia(),
    ),
  );
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


class AgriPedia extends StatelessWidget {
  const AgriPedia({Key? key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigationBarState> navigationKey = GlobalKey<NavigationBarState>();

    return MaterialApp(
      title: 'AgriPedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat'),
      routes: {
        '/second': (context) => MyNavigation(key: navigationKey),
      },
      home: const MyWelcomePage(),
    );
  }
}




class MyWelcomePage extends StatefulWidget {
  const MyWelcomePage({Key? key}) : super(key: key);

  @override
  State<MyWelcomePage> createState() => _MyWelcomePageState();
}

class _MyWelcomePageState extends State<MyWelcomePage> {
  double? crop_name;
  //final _cropStream = Supabase.instance.client.from('crop_list').stream(primaryKey: ['id']);


  @override
  void initState() {
    super.initState();
    fetchCrop();
    Future.delayed(const Duration(seconds: 5)).then((value) => {
      FlutterNativeSplash.remove()
    });
  }

  Future<void> fetchCrop() async {
    try {
      final response = await Supabase.instance.client
          .from('hardwareTest')
          .select('temperature')
          .order('id', ascending: false)
          .limit(1)
          .single();

      setState(() {
        crop_name = response['temperature'];
      });
    } catch (error) {
      print('Error fetching crop: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(0),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg-gradient.png'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SvgPicture.asset('assets/bg-welcome.svg', height: 580, width: 550,),
            const Text(
              'Monitoring Crop Growth',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 25,),
            if(crop_name != null)
              Text(
                'Crop name: $crop_name',
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            const Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 293,
                child: Text(
                  'Effortlessly track and enhance crop growth with our advanced monitoring solutions.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 52.5),
            SizedBox(
              width: 191,
              height: 51,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/second');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(247, 179, 24, 1),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
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
