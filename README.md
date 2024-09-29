# LinguaFlow - Application de Traduction avec Historique

LinguaFlow est une application mobile de traduction simple et efficace, qui permet de traduire du texte d'une langue à une autre en utilisant l'API OpenAI. L'application dispose également d'un historique des traductions effectuées, et permet de copier les résultats pour une utilisation ultérieure.

## Fonctionnalités

- **Traduction multilingue** : Traduisez facilement du texte entre plusieurs langues.
- **Correction grammaticale** : Corrigez automatiquement les fautes d'orthographe et de grammaire avant la traduction.
- **Historique des traductions** : Conservez un historique des traductions effectuées et supprimez-le à tout moment.
- **Copie des traductions** : Copiez facilement les résultats de la traduction ou l'historique des traductions dans le presse-papiers.
- **Design moderne et intuitif** : Interface utilisateur simple et élégante avec une navigation fluide.

## Technologies utilisées

- **Flutter** : Framework pour créer des applications mobiles multiplateformes.
- **Hive** : Base de données locale légère pour conserver l'historique des traductions.
- **OpenAI API** : Utilisée pour la traduction et la correction grammaticale.
- **Google Fonts** : Personnalisation des polices dans l'application.
- **Flutter Dotenv** : Gestion des variables d'environnement pour sécuriser les clés API.

## Installation

1. Clonez ce dépôt GitHub sur votre machine locale :
   ```bash
   git clone https://github.com/votre-nom-utilisateur/linguaflow.git

2. Installez les dépendances du projet :

    cd linguaflow

3. Créez un fichier .env à la racine du projet et ajoutez vos clés API OpenAI :
   - API_KEY=sk-votre-clé-openai
   - BASE_URL=https://api.openai.com/v1/chat/completions

4. Lancez l'application sur un émulateur ou un appareil connecté :
   flutter run

Enjoy 




