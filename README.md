
# Sekopercinta Flutter App

Sekopercinta is a mobile app build with [Flutter](https://flutter.dev/) with main feature is learning system for a women. The features are video player, audio player, mini game, etc.

## Getting Started

Clone the project

```bash
  git clone https://github.com/arayhann/sekopercinta.git
```

Go to the project directory

```bash
  cd sekopercinta
```

Install dependencies

```bash
  flutter pub get
```

Start the app

```bash
  flutter run
```


## Folder Structure

When working on flutter, lib is the main folder you will be almost working on.
In the lib folder, I abstract the code with several folder:

- components
- page
- providers
- utils




## Design Pattern

I am using provider pattern for this app using [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
. You can learn how to use flutter riverpod in this [documentation](https://riverpod.dev/)

I also use [flutter_hooks](https://pub.dev/packages/flutter_hooks) for handling the app lifecycle easly, using useState, useEffect, useMemoized, etc.

Fetching Data

Because the Back-End uses Hasura GraphQL, so for fetching data I use hasura_connect package. This is an example of how to use it.

final hasuraConnect = HasuraConnect(
    'https://sekopercinta.braga.co.id/v1/graphql',
    interceptors: [TokenInterceptor(ref.watch(authProvider), ref)],
);

String docQuery = """
query MyQuery {
  sumber_aktivitas_by_pk(id_aktivitas: "$activityId") {
    konten
  }
}
""";

final response = await hasuraConnect.query(docQuery);
final responseData = response['data'];

Opening New Page

I created a page transition global function for opening a new page. You just need to create a new Flutter Widget and call the function like this:

import the global function:

import 'package:sekopercinta/utils/page_transition_builder.dart';

call the function like this:

Navigator.of(context).pushReplacement(createRoute(page: OnBoardingSignUpPage(), arguments: signUpData.value));

