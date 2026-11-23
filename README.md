# cv_flutter_joseph

Application mobile Flutter d’Abbé Joseph Siringi. Elle présente le curriculum vitæ et les coordonnées, puis gère les membres de la famille à travers l’API REST du cours.

Le TP1 affichait le parcours, la famille et le contact après une connexion de démonstration. Le TP2 remplace cette connexion simulée par les comptes de l’API, et enregistre la famille dans la base de données du serveur.

- Dépôt du projet : [josingka-ctrl/cv_flutter_joseph](https://github.com/josingka-ctrl/cv_flutter_joseph)
- API du professeur : [espoirbaraka/api-test](https://github.com/espoirbaraka/api-test)

## Technologies

- Flutter et Dart (SDK `^3.14.0`)
- `http` pour les appels REST
- `image_picker` pour la photo facultative d’un membre
- `url_launcher` pour le téléphone, l’e-mail, l’adresse, WhatsApp et GitHub
- `material_ui` pour l’interface

L’API consommée est le projet PHP du professeur. Elle répond en JSON et enregistre les comptes ainsi que les membres dans MySQL. Ce dépôt Flutter ne contient pas cette API : elle doit être installée à part, selon son README.

## Fonctionnalités

Après une connexion acceptée par le serveur, la barre du bas et le menu latéral ouvrent trois pages : Mon CV, Ma famille et Contact. Le menu permet aussi de se déconnecter.

Le CV et le contact restent des pages de présentation. Les liens de contact (appel, e-mail, carte, WhatsApp, GitHub) sont cliquables.

La famille n’est plus une liste fixe dans l’application. Chaque opération passe par l’API.

| Action | Méthode et chemin |
| --- | --- |
| Créer un compte | `POST /accounts/register` |
| Se connecter | `POST /accounts/login` |
| Consulter les membres | `GET /famille-membres` |
| Ajouter un membre | `POST /famille-membres` |
| Modifier un membre | `PUT /famille-membres/{id}` |
| Modifier un membre et sa photo | `POST /famille-membres/{id}` |
| Supprimer un membre | `DELETE /famille-membres/{id}` |

L’inscription envoie l’email et le mot de passe. Le mot de passe doit contenir au moins 6 caractères, et la confirmation doit être identique. Si l’email existe déjà, le message renvoyé par l’API est affiché. Une inscription réussie ouvre l’application.

La connexion n’accepte que un email et un mot de passe reconnus par `POST /accounts/login`. Un échec reste sur le formulaire et affiche le message du serveur. Un champ vide ou un email mal formé est signalé avant l’appel.

Un membre comprend le nom, le postnom, le prénom, le lieu de naissance, la date de naissance (`AAAA-MM-JJ`) et le lien de parenté. La photo est facultative. Sans photo, l’ajout et la modification partent en JSON. Avec une photo, la requête est envoyée en `multipart/form-data`. Le changement de photo utilise `POST` sur l’adresse du membre, parce que l’API ne reçoit pas de fichier en `PUT`. La suppression demande une confirmation, puis appelle `DELETE`.

La liste est relue sur le serveur à l’ouverture de la page, au glissement vers le bas, et après un ajout, une modification ou une suppression. Les formulaires contrôlent les champs obligatoires, leur longueur et la date. Si le serveur est injoignable, trop lent, ou répond par une erreur, le message est affiché dans l’écran concerné.

## Installation

### 1. API et base de données

Installer le dépôt [api-test](https://github.com/espoirbaraka/api-test) comme l’indique son README : Apache et MySQL, base `api`, import de `api.sql`. L’application attend l’API à l’adresse suivante, segment `/public` compris.

```text
http://localhost/api-test/public
```

Sans ce serveur, la connexion et la famille ne peuvent pas aboutir : les données ne sont pas conservées dans le téléphone.

### 2. Application Flutter

```bash
git clone https://github.com/josingka-ctrl/cv_flutter_joseph.git
cd cv_flutter_joseph
flutter pub get
```

## Exécution

Démarrer Apache et MySQL, puis lancer l’application :

```bash
flutter run
```

Sur l’émulateur Android, l’application appelle `http://10.0.2.2/api-test/public`, c’est-à-dire l’ordinateur hôte. Sur Windows, Linux ou dans le navigateur, elle appelle `http://127.0.0.1/api-test/public` ou `http://localhost/api-test/public`.

Pour un téléphone physique, indiquer l’adresse IP de l’ordinateur :

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.10/api-test/public
```

Remplacer `192.168.1.10` par l’adresse réelle de la machine qui héberge l’API. Le téléphone et l’ordinateur doivent être sur le même réseau.

Créer ensuite un compte depuis l’écran « Créer un compte », puis se reconnecter plus tard avec le même email et le même mot de passe.

## Démonstration vidéo

La vidéo de démonstration n’est pas encore liée. Coller son URL à la place du texte ci-dessous.

**Lien de la vidéo :** `COLLEZ_LE_LIEN_ICI`
