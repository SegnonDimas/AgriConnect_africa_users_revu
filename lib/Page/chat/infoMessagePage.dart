import 'package:agribenin/Page/app_colors.dart';
import 'package:agribenin/Page/screen/app_sizes.dart';
import 'package:agribenin/Page/screen/text_sizes.dart';
import 'package:agribenin/Page/styles/appTexts.dart';
import 'package:agribenin/Page/styles/messageModel.dart';
import 'package:flutter/material.dart';

class InfoMessagePage extends StatefulWidget {
  //final MessageModel Message;

  const InfoMessagePage({
    super.key,
    //required this.Message
  });

  @override
  State<InfoMessagePage> createState() => _InfoMessagePageState();
}

class _InfoMessagePageState extends State<InfoMessagePage> {
  String text = '''  
    **Politique de Confidentialité de l'Application Mobile "PouletExpress"**

Dernière mise à jour : [Date]

Bienvenue sur PouletExpress, l'application mobile dédiée à simplifier votre expérience d'achat de poulet de qualité. La confidentialité de vos informations est d'une importance capitale pour nous. Cette politique de confidentialité vise à vous informer sur la manière dont nous recueillons, utilisons et protégeons vos données personnelles lors de l'utilisation de notre application mobile.

### 1. Collecte d'Informations

**1.1 Informations que vous nous fournissez volontairement :**
Lors de l'inscription et de l'utilisation de PouletExpress, vous pouvez être amené à fournir des informations telles que votre nom, adresse, numéro de téléphone et adresse e-mail. Ces données sont nécessaires pour la gestion de votre compte et le traitement de vos commandes.

**1.2 Données de paiement :**
Pour faciliter les transactions, nous pouvons collecter des informations de paiement, telles que les détails de votre carte de crédit ou d'autres méthodes de paiement. Soyez assuré que ces données sont traitées de manière sécurisée et conformément aux normes de sécurité en vigueur.

### 2. Utilisation des Informations

Nous utilisons vos informations personnelles aux fins suivantes :

**2.1 Traitement des commandes :**
Les données que vous fournissez sont utilisées pour traiter vos commandes, assurer la livraison des produits et vous tenir informé du statut de votre commande.

**2.2 Communication :**
Nous pouvons vous envoyer des notifications, des mises à jour de commande et des informations promotionnelles liées à PouletExpress, avec votre consentement préalable.

**2.3 Amélioration de l'expérience utilisateur :**
Vos commentaires et comportements d'utilisation nous aident à améliorer constamment notre application pour mieux répondre à vos besoins et préférences.

### 3. Partage d'Informations

Nous ne vendons, ne louons ni ne partageons vos informations personnelles avec des tiers non autorisés, sauf dans les cas suivants :

- Avec votre consentement explicite.
- Pour répondre aux exigences légales et réglementaires.
- En cas de fusion, acquisition ou cession de l'entreprise.

### 4. Sécurité des Données

Nous mettons en place des mesures de sécurité appropriées pour protéger vos informations contre tout accès non autorisé, divulgation, altération ou destruction.

### 5. Vos Choix et Contrôles

Vous avez le droit de mettre à jour, corriger ou supprimer vos informations personnelles à tout moment. Vous pouvez également choisir de ne pas recevoir nos communications promotionnelles en ajustant vos préférences dans les paramètres de l'application.

### 6. Modifications de la Politique de Confidentialité

Cette politique de confidentialité peut être mise à jour périodiquement. Les modifications seront publiées sur notre site web et vous seront notifiées par le biais de l'application.

En utilisant PouletExpress, vous acceptez les termes de cette politique de confidentialité. Si vous avez des questions ou des préoccupations, veuillez nous contacter à l'adresse [contact@pouletexpress.com].

Merci d'avoir choisi PouletExpress pour votre expérience d'achat de poulet de qualité !
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                height: appHeightSize(context) * 0.4,
                decoration: BoxDecoration(color: primaryColor.withOpacity(0.1)),
                child: SingleChildScrollView(
                  // child: widget.Message,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      MessageModel(
                        sendDate: '18/02/2024 23:33 PM',
                        message: text,
                        isRead: true,
                        sendByAdmin: true,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  title: AppText(
                      text: 'Envoyé par : ',
                      color: Colors.grey,
                      size: mediumText() * 0.8,
                      bold: false,
                      justify: false,
                      center: false),
                  trailing: Text(
                    'Admin',
                    style: TextStyle(
                        color: Colors.white, fontSize: mediumText() * 0.85),
                  )),
              ListTile(
                  leading: const Icon(
                    Icons.calendar_month,
                    color: Colors.grey,
                  ),
                  title: AppText(
                      text: 'Date et heure : ',
                      color: Colors.grey,
                      size: mediumText() * 0.8,
                      bold: false,
                      justify: false,
                      center: false),
                  trailing: Text(
                    '18/02/2024 23:33 PM',
                    style: TextStyle(
                        color: Colors.white, fontSize: mediumText() * 0.85),
                  )),
              ListTile(
                  leading: const Icon(
                    Icons.done_all,
                    color: Colors.blue,
                  ),
                  title: AppText(
                      text: 'Lu ? : ',
                      color: Colors.grey,
                      size: mediumText() * 0.8,
                      bold: false,
                      justify: false,
                      center: false),
                  trailing: Text(
                    'Oui',
                    style: TextStyle(
                        color: Colors.white, fontSize: mediumText() * 0.85),
                  )),
            ],
          ),
          Container(
            height: appHeightSize(context) * 0.12,
            //color: darkColor.withOpacity(0.4),
            decoration: BoxDecoration(
              color: darkColor.withOpacity(0.5),
              //borderRadius: BorderRadius.circular(20)
            ),
            child: AppBar(
              foregroundColor: Colors.white,
              forceMaterialTransparency: true,
              title: Text(
                'Infos du message',
                style: TextStyle(fontSize: mediumText() * 1.18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
