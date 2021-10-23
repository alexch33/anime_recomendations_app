### Anime recommendations app

<table>
    <tr>
        <td>
        <img src="https://github.com/lexch13/anime_recomeder_app/blob/master/assets/screenshots/1.png?raw=true"/>
        </td>
        <td>
        <img src="https://github.com/lexch13/anime_recomeder_app/blob/master/assets/screenshots/2.png?raw=true"/>
        </td>
    </tr>
    <tr>
        <td>
        <img src="https://github.com/lexch13/anime_recomeder_app/blob/master/assets/screenshots/3.png?raw=true"/>
        </td>
        <td>
        <img src="https://github.com/lexch13/anime_recomeder_app/blob/master/assets/screenshots/4.png?raw=true"/>
        </td>
    </tr>
    <tr>
        <td>
        <img src="https://github.com/lexch13/anime_recomeder_app/blob/master/assets/screenshots/5.png?raw=true"/>
        </td>
        <td>
        <img src="https://github.com/lexch13/anime_recomeder_app/blob/master/assets/screenshots/6.png?raw=true"/>
        </td>
    </tr>
</table>

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/i3po/anime_recomeder_app
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:**

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

or watch command in order to keep the source code synced automatically:

```
flutter packages pub run build_runner watch
```
**Step 4:**
Start api

```
https://github.com/i3po/anime_recomender_api
```

## Hide Generated Files

In-order to hide generated files, navigate to `Android Studio` -> `Preferences` -> `Editor` -> `File Types` and paste the below lines under `ignore files and folders` section:

```
*.inject.summary;*.inject.dart;*.g.dart;
```

In Visual Studio Code, navigate to `Preferences` -> `Settings` and search for `Files:Exclude`. Add the following patterns:
```
**/*.inject.summary
**/*.inject.dart
**/*.g.dart
```

