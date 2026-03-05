import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const ToolBoxApp());

class ToolBoxApp extends StatelessWidget {
  const ToolBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToolBox App multiuzos',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff6e29a4)),
      ),
      home: const MainWrapper(),
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});
  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  Widget _currentView = const HomeView();
  String _title = "Caja de herramientas";

  void _updateView(Widget view, String title) {
    setState(() {
      _currentView = view;
      _title = title;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Color(0xff6e29a4),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xff6e29a4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/MiFoto.jpeg'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Menú Principal',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            _menuItem("Inicio", Icons.home, const HomeView()),
            _menuItem("Género", Icons.people, const GenderView()),
            _menuItem("Edad", Icons.cake, const AgeView()),
            _menuItem("Universidades", Icons.school, const UniversityView()),
            _menuItem("Clima RD", Icons.cloud, const WeatherView()),
            _menuItem("Pokémon", Icons.catching_pokemon, const PokemonView()),
            _menuItem("Noticias WP", Icons.newspaper, const WordPressView()),
            _menuItem("Acerca de", Icons.info, const AboutView()),
          ],
        ),
      ),
      body: _currentView,
    );
  }

  ListTile _menuItem(String title, IconData icon, Widget view) {
    return ListTile(
      leading: Icon(icon, color: Color(0xff6e29a4)),
      title: Text(title),
      onTap: () => _updateView(view, title),
    );
  }
}

// 1. Inicio
class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/CajaHerramientas.png', height: 220),
          const SizedBox(height: 20),
          const Text("ToolBox App multiusos",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff6e29a4))),
          const Text("Caja de herramientas", style: TextStyle(fontSize: 16)),
          const Text("Tu real navaja suiza pero en tu celular"),
          const SizedBox(height: 10),
          const Text("Selecciona una opción en el menú lateral"),
        ],
      ),
    );
  }
}

// 2. Vista del predictor de genero
class GenderView extends StatefulWidget {
  const GenderView({super.key});
  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  final TextEditingController _ctrl = TextEditingController();
  Color color = Colors.white;
  String genderText = "Escribe un nombre";

  Future<void> predict() async {
    if (_ctrl.text.isEmpty) return;
    final res = await http
        .get(Uri.parse('https://api.genderize.io/?name=${_ctrl.text}'));
    final data = jsonDecode(res.body);
    setState(() {
      color = (data['gender'] == 'male')
          ? Colors.blue.shade100
          : Colors.pink.shade100;
      genderText =
          (data['gender'] == 'male') ? "Es Masculino ♂" : "Es Femenino ♀";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: color,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
              controller: _ctrl,
              decoration: const InputDecoration(labelText: "Nombre")),
          ElevatedButton(onPressed: predict, child: const Text("Predecir")),
          const SizedBox(height: 30),
          Text(genderText,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// 3. Vista de predecir edad
class AgeView extends StatefulWidget {
  const AgeView({super.key});
  @override
  State<AgeView> createState() => _AgeViewState();
}

class _AgeViewState extends State<AgeView> {
  final TextEditingController _ctrl = TextEditingController();
  int age = 0;
  String status = "";
  String imgUrl =
      "https://cdn-icons-png.flaticon.com/512/3077/3077325.png"; // Placeholder

  Future<void> predictAge() async {
    if (_ctrl.text.isEmpty) return;
    final res =
        await http.get(Uri.parse('https://api.agify.io/?name=${_ctrl.text}'));
    final data = jsonDecode(res.body);
    setState(() {
      age = data['age'] ?? 0;
      if (age < 30) {
        status = "Joven";
        imgUrl = "https://cdn-icons-png.flaticon.com/512/3468/3468306.png";
      } else if (age < 60) {
        status = "Adulto";
        imgUrl = "https://cdn-icons-png.flaticon.com/512/3048/3048122.png";
      } else {
        status = "Anciano";
        imgUrl =
            "https://static.vecteezy.com/system/resources/previews/011/858/468/original/happy-elderly-woman-png.png";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
              controller: _ctrl,
              decoration: const InputDecoration(labelText: "Nombre")),
          ElevatedButton(
              onPressed: predictAge, child: const Text("Determinar")),
          const SizedBox(height: 20),
          if (age > 0) ...[
            Text("Edad: $age años", style: const TextStyle(fontSize: 22)),
            Text("Estado: $status",
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.network(imgUrl, height: 150),
          ]
        ],
      ),
    );
  }
}

// 4. Vista universidades de cada pais
class UniversityView extends StatefulWidget {
  const UniversityView({super.key});
  @override
  State<UniversityView> createState() => _UniversityViewState();
}

class _UniversityViewState extends State<UniversityView> {
  final TextEditingController _ctrl = TextEditingController();
  List universities = [];

  Future<void> fetch() async {
    final country = _ctrl.text.replaceAll(' ', '+');
    final res = await http
        .get(Uri.parse('https://adamix.net/proxy.php?country=$country'));
    setState(() {
      universities = jsonDecode(res.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
              controller: _ctrl,
              decoration: const InputDecoration(labelText: "País (en Inglés)")),
        ),
        ElevatedButton(onPressed: fetch, child: const Text("Buscar")),
        Expanded(
          child: ListView.builder(
            itemCount: universities.length,
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(universities[i]['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(universities[i]['domains'][0]),
                trailing: const Icon(Icons.language),
                onTap: () =>
                    launchUrl(Uri.parse(universities[i]['web_pages'][0])),
              ),
            ),
          ),
        )
      ],
    );
  }
}

// 5. Vista clima RD
class Weather {
  final int humidity;
  final double temperature;
  final double windSpeed;
  final int windDirection;
  final int weatherCode;

  Weather({
    required this.humidity,
    required this.temperature,
    required this.weatherCode,
    required this.windDirection,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      humidity: json['current']['relative_humidity_2m'] ?? 0,
      temperature: (json['current']['temperature_2m'] as num).toDouble(),
      windSpeed: (json['current']['wind_speed_10m'] as num).toDouble(),
      windDirection: json['current']['wind_direction_10m'] ?? 0,
      weatherCode: json['current']['weather_code'] ?? 0,
    );
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});
  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  Weather? weatherData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  // Traducción de los códigos de Open-Meteo
  String _getDesc(int code) {
    if (code == 0) return "Cielo despejado";
    if (code <= 3) return "Parcialmente nublado";
    if (code <= 48) return "Niebla";
    if (code <= 55) return "Llovizna";
    if (code <= 65) return "Lluvia";
    if (code <= 82) return "Aguaceros";
    return "Tormenta eléctrica";
  }

  Future<void> fetchWeather() async {
    try {
      final url = Uri.parse(
          "https://api.open-meteo.com/v1/forecast?latitude=18.4719&longitude=-69.8923&current=relative_humidity_2m,temperature_2m,wind_speed_10m,wind_direction_10m,weather_code&timezone=auto");
      final res = await http.get(url);
      if (res.statusCode == 200) {
        setState(() {
          weatherData = Weather.fromJson(json.decode(res.body));
          loading = false;
        });
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: loading
          ? const CircularProgressIndicator()
          : weatherData == null
              ? const Text("Error al cargar datos")
              : Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const Text("Santo Domingo, RD",
                            style: TextStyle(fontSize: 18)),
                        Text("${weatherData!.temperature}°C",
                            style: const TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold)),
                        Text(_getDesc(weatherData!.weatherCode),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.blueGrey)),
                        const SizedBox(height: 10),
                        Text(
                            "Humedad: ${weatherData!.humidity}% | Viento: ${weatherData!.windSpeed} km/h"),
                      ],
                    ),
                  ),
                ),
    );
  }
}

// 6. Vista Pokemon
class PokemonView extends StatefulWidget {
  const PokemonView({super.key});
  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  final TextEditingController _ctrl = TextEditingController();
  Map<String, dynamic>? data;

  Future<void> fetchPokemon() async {
    final name = _ctrl.text.toLowerCase().trim();
    if (name.isEmpty) return;
    try {
      final res =
          await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));
      setState(() => data = jsonDecode(res.body));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pokémon no encontrado")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
              controller: _ctrl,
              decoration:
                  const InputDecoration(labelText: "Nombre del Pokémon")),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: fetchPokemon, child: const Text("Ver Pokémon")),
          if (data != null) ...[
            const SizedBox(height: 20),
            Image.network(data!['sprites']['front_default'],
                height: 200, fit: BoxFit.contain),
            Text(data!['name'].toString().toUpperCase(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Experiencia Base: ${data!['base_experience']}"),
            const SizedBox(height: 10),
            const Text("Habilidades:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                data!['abilities'].map((a) => a['ability']['name']).join(', ')),
          ]
        ],
      ),
    );
  }
}

// 7. Vista Wordpress
class WordPressView extends StatefulWidget {
  const WordPressView({super.key});
  @override
  State<WordPressView> createState() => _WordPressViewState();
}

class _WordPressViewState extends State<WordPressView> {
  List posts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      // TechCrunch con per_page=3 para asegurar las 3 ultimas noticias.
      final res = await http.get(
          Uri.parse('https://techcrunch.com/wp-json/wp/v2/posts?per_page=3'));
      setState(() {
        posts = jsonDecode(res.body);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/9/93/Wordpress_Blue_logo.png',
            height: 60),
        const Divider(),
        if (loading) const Center(child: CircularProgressIndicator()),
        Expanded(
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(posts[i]['title']['rendered'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    // Limpiando el texto del resumen de etiquetas HTML con regex
                    Text(
                        posts[i]['excerpt']['rendered']
                            .toString()
                            .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''),
                        maxLines: 3),
                    TextButton(
                      onPressed: () => launchUrl(Uri.parse(posts[i]['link'])),
                      child: const Text("Visitar noticia original"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 8. Vista para contactarme
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  // Función para abrir aplicaciones externas
  void _launch(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage('assets/MiFoto.jpeg'),
          ),
          const SizedBox(height: 15),
          const Text("Arwin D. Clark Peralta",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("Desarrolladora de software",
              style: TextStyle(color: Color(0xff965bc3))),
          const SizedBox(height: 20),
          const Divider(),
          const Text("¡Hablemos!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.red),
            title: const Text("Arwinclarkperalta@gmail.com"),
            onTap: () => _launch(
                "mailto:arwinclarkperalta@gmail.com?subject=Contacto desde App"),
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.green),
            title: const Text("Enviar WhatsApp"),
            subtitle: const Text("O presiona para llamar"),
            onTap: () => _launch("https://wa.me/18299337248"),
            onLongPress: () => _launch("tel:+18299337248"),
          ),
        ],
      ),
    );
  }
}
