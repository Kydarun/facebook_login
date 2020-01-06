@JS()
library load_fbapi;

import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/services.dart' show rootBundle;
import 'package:js/js.dart';

@JS()
external set fbApiOnloadCallback(Function callback);

Future<void> inject() {
  final Completer<void> fbApiOnLoad = Completer<void>();
  fbApiOnloadCallback = allowInterop(() {
    fbApiOnLoad.complete();
  });

  return Future.wait(
      <Future<void>>[injectJSLibraries(['https://connect.facebook.net/en_US/sdk.js']), fbApiOnLoad.future]);
}

Future<void> injectJSLibraries(List<String> libraries,
    {html.HtmlElement target /*, Duration timeout */}) async {
  final List<Future<void>> loading = <Future<void>>[];
  final List<html.HtmlElement> tags = <html.HtmlElement>[];

  libraries.forEach((String library) {
    final html.ScriptElement script = html.ScriptElement()
      ..async = true
      ..defer = true
      ..src = library;
    loading.add(script.onLoad.first);
    tags.add(script);
  });
  final html.ScriptElement initScript = html.ScriptElement();
  String fbID = html.querySelector('meta[name=fb-app-id]')?.getAttribute('content') ?? '';
  String fbInitScript = await rootBundle.loadString('fb_init.js').catchError((e, stacktrace) {
    print('$e');
    print('$stacktrace');
  });
  initScript.appendText(fbInitScript.replaceAll('[APP-ID]', fbID));
  (target ?? html.querySelector('head')).children.addAll(tags);
  return Future.wait(loading);
}

Future<void> init() => inject();

