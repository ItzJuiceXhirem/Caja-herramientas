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
      title: 'ToolBox Dominicana',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
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
  int _selectedIndex = 0;

  final List<Widget> _views = [
    const HomeView(),
    const GenderView(),
    const AgeView(),
    const UniversityView(),
    const WeatherView(),
    const PokemonView(),
    const WordPressView(),
    const AboutView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Herramientas Multi-uso"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    // ESTE ES TU ICONO LOCAL EN EL MENÚ
                    backgroundImage: AssetImage('assets/MiFoto.jpeg'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Menú Principal',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            _buildItem(0, "Inicio", Icons.home),
            _buildItem(1, "Predecir Género", Icons.people),
            _buildItem(2, "Determinar Edad", Icons.cake),
            _buildItem(3, "Universidades", Icons.school),
            _buildItem(4, "Clima RD", Icons.cloud),
            _buildItem(5, "Pokémon", Icons.catching_pokemon),
            _buildItem(6, "Noticias WordPress", Icons.newspaper),
            _buildItem(7, "Acerca de", Icons.info),
          ],
        ),
      ),
      body: _views[_selectedIndex],
    );
  }

  Widget _buildItem(int index, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }
}

// 1. VISTA INICIO
class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
              'https://cdn-icons-png.flaticon.com/512/3062/3062331.png',
              height: 200),
          const SizedBox(height: 20),
          const Text("Caja de Herramientas",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// 2. GÉNERO
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
      if (data['gender'] == 'male') {
        color = Colors.blue.shade100;
        genderText = "Es Masculino ♂";
      } else {
        color = Colors.pink.shade100;
        genderText = "Es Femenino ♀";
      }
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
          const SizedBox(height: 10),
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

// 3. EDAD
class AgeView extends StatefulWidget {
  const AgeView({super.key});
  @override
  State<AgeView> createState() => _AgeViewState();
}

class _AgeViewState extends State<AgeView> {
  final TextEditingController _ctrl = TextEditingController();
  int age = 0;
  String status = "";
  String imgUrl = "https://cdn-icons-png.flaticon.com/512/3077/3077325.png";

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
        imgUrl = "https://cdn-icons-png.flaticon.com/512/2650/2650820.png";
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
              onPressed: predictAge, child: const Text("Calcular Edad")),
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

// 4. UNIVERSIDADES
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
    final res = await http.get(
        Uri.parse('https://universities.hipolabs.com/search?country=$country'));
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
        ElevatedButton(
            onPressed: fetch, child: const Text("Buscar Universidades")),
        Expanded(
          child: ListView.builder(
            itemCount: universities.length,
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(universities[i]['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(universities[i]['domains'][0]),
                trailing: const Icon(Icons.open_in_new, size: 18),
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

// 5. CLIMA RD
class WeatherView extends StatelessWidget {
  const WeatherView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wb_sunny, size: 80, color: Colors.orange),
              const Text("Santo Domingo, RD", style: TextStyle(fontSize: 22)),
              const Text("31°C",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
              Text("Soleado",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
            ],
          ),
        ),
      ),
    );
  }
}

// 6. POKEMON
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
                height: 150, fit: BoxFit.contain),
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

// 7. WORDPRESS
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
    // Usando TechCrunch como ejemplo de sitio WP
    final res = await http.get(
        Uri.parse('https://techcrunch.com/wp-json/wp/v2/posts?per_page=3'));
    setState(() {
      posts = jsonDecode(res.body);
      loading = false;
    });
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

// 8. ACERCA DE - USANDO TU FOTO LOCAL
class AboutView extends StatelessWidget {
  const AboutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 80,
            backgroundColor: Colors.indigo,
            // CARGA TU FOTO LOCAL AQUÍ
            backgroundImage: AssetImage('assets/MiFoto.jpeg'),
          ),
          const SizedBox(height: 20),
          const Text("Tu Nombre Completo",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const Text("Desarrollador de Aplicaciones Móviles",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 30),
          const Card(
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                ListTile(
                    leading: Icon(Icons.email),
                    title: Text("tu.correo@ejemplo.com")),
                ListTile(
                    leading: Icon(Icons.phone), title: Text("+1 809-XXX-XXXX")),
                ListTile(
                    leading: Icon(Icons.work),
                    title: Text("Disponible para proyectos")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
