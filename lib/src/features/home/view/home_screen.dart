import 'package:adaptive_components/adaptive_components.dart';
import 'package:flutter/material.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/extensions.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/views/views.dart';
import '../../playlists/view/playlist_songs.dart';
import 'view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final PlaylistsProvider playlistProvider = PlaylistsProvider();
    final List<Playlist> playlists = playlistProvider.playlists;
    final Playlist topSongs = playlistProvider.topSongs;
    final Playlist newReleases = playlistProvider.newReleases;
    final ArtistsProvider artistsProvider = ArtistsProvider();
    final List<Artist> artists = artistsProvider.artists;

    //  It's common (and recommended!) to hide features
    //  on mobile that only make sense on large screens and form factors.
    return LayoutBuilder(
      builder: (context, constraints) {
        // Conditional mobile layout
        if (constraints.isMobile) {
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: const Text('Good morning'),
                actions: const [BrightnessToggle()],
                bottom: const TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'Home'),
                    Tab(text: 'Recently Played'),
                    Tab(text: 'Top Songs'),
                    Tab(text: 'New Releases'),
                  ],
                ),
              ),
              body: LayoutBuilder(
                builder: (context, constraints) => TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const HomeHighlight(),
                          HomeArtists(
                            artists: artists,
                            constraints: constraints,
                          ),
                        ],
                      ),
                    ),
                    HomeRecent(
                      playlists: playlists,
                      axis: Axis.vertical,
                    ),
                    PlaylistSongs(
                      playlist: topSongs,
                      constraints: constraints,
                    ),
                    PlaylistSongs(
                      playlist: newReleases,
                      constraints: constraints,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // non-mobile layout
        return Scaffold(
          body: SingleChildScrollView(
            child: AdaptiveColumn(
              children: [
                AdaptiveContainer(
                  columnSpan: 12,
                  child: Padding(
                    // sets left, top, right, and bottom individually
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Good morning',
                            style: context.displaySmall,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const BrightnessToggle(),
                      ],
                    ),
                  ),
                ),
                AdaptiveContainer(
                  columnSpan: 12,
                  child: Column(
                    children: [
                      const HomeHighlight(),
                      LayoutBuilder(
                        builder: (context, constraints) => HomeArtists(
                          artists: artists,
                          constraints: constraints,
                        ),
                      ),
                    ],
                  ),
                ),
                AdaptiveContainer(
                  columnSpan: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        // sets the padding for vertical (top and bottom) to be equivalent,
                        // and horizontal (left and right) to be equivalent
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Text(
                          'Recently played',
                          style: context.headlineSmall,
                        ),
                      ),
                      HomeRecent(
                        playlists: playlists,
                      ),
                    ],
                  ),
                ),
                AdaptiveContainer(
                  columnSpan: 12,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    // sets only the specified edges
                                    const EdgeInsets.only(left: 8, bottom: 8),
                                child: Text(
                                  'Top Songs Today',
                                  style: context.titleLarge,
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) =>
                                    PlaylistSongs(
                                  playlist: topSongs,
                                  constraints: constraints,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Add spacer between tables
                        const SizedBox(width: 35),
                        Flexible(
                          flex: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                // sets only the specified edges
                                const EdgeInsets.only(left: 8, bottom: 8),
                                child: Text(
                                  'New Releases',
                                  style: context.titleLarge,
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) =>
                                    PlaylistSongs(
                                  playlist: newReleases,
                                  constraints: constraints,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
