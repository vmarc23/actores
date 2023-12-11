import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies_app/api/api.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/controllers/movies_controller.dart';
import 'package:movies_app/models/actor.dart';
import 'package:movies_app/models/actordesc.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/models/review.dart';
import 'package:movies_app/screens/details_screen.dart';
import 'package:movies_app/utils/utils.dart';
import 'package:movies_app/widgets/tab_builder.dart';

class DetailsScreenActor extends StatelessWidget {
  const DetailsScreenActor({
    Key? key,
    required this.actor,
  }) : super(key: key);
  final Actor actor;

  @override
  Widget build(BuildContext context) {
    ApiService.getActors();
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Hollywood-Logo.svg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 34),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        tooltip: 'Back to home',
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Actor details',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                        ),
                      ),
                      const Tooltip(
                        message: 'Save this actor to your watch list',
                        triggerMode: TooltipTriggerMode.tap,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 200,
                  width: 500,
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500/${actor.profilepath}',
                              width: 110,
                              height: 140,
                              fit: BoxFit.fill,
                              loadingBuilder: (_, __, ___) {
                                if (___ == null) return __;
                                return const FadeShimmer(
                                  width: 110,
                                  height: 100,
                                  highlightColor: Color(0xff22272f),
                                  baseColor: Color(0xff20252d),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              actor.name,
                              style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amber),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color.fromRGBO(37, 40, 54, 0.52),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/Star.svg'),
                                  const SizedBox(width: 5),
                                  Text(
                                    actor.popularity == 0.0
                                        ? 'N/A'
                                        : actor.popularity.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFFF8700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const TabBar(
                          indicatorWeight: 4,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Color(
                            0xFF3A3F47,
                          ),
                          tabs: [
                            Tab(text: 'Description'),
                            Tab(text: 'Movies'),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          child: TabBarView(children: [
                            //DESCRIPCION DEL ACTOR
                            SingleChildScrollView(
                              child: FutureBuilder<ActorDesc?>(
                                future: ApiService.getActorsDesc(actor.id),
                                builder: (_, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    // Muestra un mensaje de error si hay algún problema con la solicitud
                                    print("Error: ${snapshot.error}");
                                    return const Center(
                                        child: Text(
                                            'Error al cargar la biografía.'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    // Muestra un mensaje si no hay datos disponibles
                                    return const Center(
                                        child: Text(
                                            'No se encontró la biografía.'));
                                  } else {
                                    // Muestra la biografía
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.biography,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),

                            //PELICULAS DONDE APARECE EL ACTOR (AL DAR CLIC NOS APARECEN LOS DETALLES DE ESTA)
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal, // Permite el desplazamiento horizontal
                                itemCount: actor.peliculas.length,
                                itemBuilder: (context, index) {
                                  Movie movie = actor.peliculas[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0), // Añadir espacio entre elementos
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() =>
                                                DetailsScreen(movie: movie));
                                          },
                                          child: Image.network(
                                            Api.imageBaseUrl + movie.posterPath,
                                            width: 100,
                                            height: 150, 
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                8), // Ajusta el espacio entre la imagen y el texto
                                        Text(
                                          movie.title,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                        Text(
                                          movie.releaseDate,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
