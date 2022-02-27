import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/ui/drawer/drawer_view.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'watch_list_view_model.dart';

class WatchListView extends StatelessWidget {
  const WatchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WatchListViewModel>(
      init: WatchListViewModel(),
      builder: (model) => model.isLoading
          ? Scaffold(body: Center(child: CircularProgressIndicator()))
          : BasicPage(
              leftIconButton: IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  Get.back();
                },
              ),
              rightIconButton: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  model.refreshList();
                },
              ),
              drawer: DrawerView(),
              child: model.movies.isEmpty
                  ? Center(
                      child: Text('No movies right now.'),
                    )
                  : ListView.builder(
                      primary: true,
                      shrinkWrap: true,
                      itemCount: model.movies.length,
                      itemBuilder: (BuildContext context, int index) {
                        final MovieModel movie = model.movies[index];
                        return ListTile(
                          onTap: () async {
                            Get.toNamed(
                              Globals.ROUTES_MOVIE_DETAILS,
                              arguments: {
                                'movie': movie,
                              },
                            );
                          },
                          title: Text(
                            '${movie.title}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          leading: SizedBox(
                            height: 100,
                            width: 35,
                            child: CachedNetworkImage(
                              imageUrl: '${movie.poster}',
                              imageBuilder: (context, imageProvider) => Image(
                                image: imageProvider,
                                height: 100,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    ),
              title: 'Watch List',
            ),
    );
  }
}
