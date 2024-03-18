import 'package:agribenin/Page/app_colors.dart';
import 'package:agribenin/authentification/inscription.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/cons.dart';

class PolitiqueEtConfidantialite extends StatefulWidget {
  bool isRead;
  PolitiqueEtConfidantialite({
    required this.isRead,
    super.key});

  @override
  State<PolitiqueEtConfidantialite> createState() =>
      _PolitiqueEtConfidantialiteState();
}


class _PolitiqueEtConfidantialiteState extends State<PolitiqueEtConfidantialite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _transform;
  bool isClick = false;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });

    _transform = Tween<double>(begin: 2, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    isClick = widget.isRead;
    String title = 'CONTRAT D\'UTILISATION DE LA PLATEFORME AGRICONNECT AFRICA';
    String politiqueDeConfidentialite = '''
    
PRÉAMBULE

La plateforme AgriConnect Africa est une solution développée par Digital Farm Afrik SARL, une société de droit béninois, dont le siège social est situé à Abomey Calavi, Godomey, République du Bénin, et immatriculée au RCCM N° RB/ABC/23 B 7364  ayant pour IFU : 3202386790413.
La plateforme AgriConnect Africa a pour objet de fournir aux agriculteurs africains des services de : 
Accès aux prévisions agro-hydro-climatiques ; 
Accès aux innovations et technologies résilientes face aux changements climatiques et issues recherches scientifiques ;
Signalement de récoltes en vue d’un meilleur accès aux marchés ;
Assistance technique pour une meilleure production.
Les présentes conditions générales d'utilisation (CGU) ont pour but de définir les modalités et les conditions d'accès et d'utilisation de la plateforme AgriConnect Africa, ainsi que les droits et obligations de Digital Farm Afrik et des utilisateurs.
En s'inscrivant sur la plateforme AgriConnect Africa, l'utilisateur reconnaît avoir pris connaissance et accepté sans réserve les présentes CGU.

Article 1 : Définitions

    Dans les présentes CGU, les termes suivants ont la signification indiquée ci-dessous :
- Plateforme : désigne la plateforme numérique AgriConnect Africa, accessible via l'application mobile téléchargeable sur les stores.
- Utilisateur : désigne toute personne physique ou morale qui s'inscrit sur la plateforme et qui bénéficie des services fournis par AgriConnect Africa.
- Services : désigne les services, énumérés au préambule et proposés par Digital Farm Afrik sur la plateforme.
- Données personnelles : désigne toute information se rapportant à une personne physique identifiée ou identifiable, telle que son nom, son prénom, son adresse, son numéro de téléphone, son adresse e-mail, etc.

Article 2 : Inscription sur la plateforme

  Pour accéder aux services de la plateforme, l'utilisateur doit s'inscrire en remplissant le formulaire y figurant et en fournissant les informations demandées à savoir : son nom, son prénom, son adresse e-mail, son numéro de téléphone, son pays, sa région, son secteur d'activité, sa photo de profil, sa langue locales la plus comprise et parlée.
L'utilisateur s'engage à fournir des informations exactes, complètes, et à les mettre à jour en cas de modification.
L'utilisateur est responsable de la conservation et de l'utilisation de ses identifiants, lesquels sont relatifs à son numéro de téléphone renseigné à l’inscription. 
En cas de perte, de vol ou d'utilisation frauduleuse de ses identifiants, l'utilisateur doit en informer immédiatement Digital Farm Afrik.
L'inscription sur la plateforme est gratuite et donne accès à un espace personnel où l'utilisateur peut consulter et gérer ses données, ses abonnements aux services, ses demandes et ses réclamations. Toutefois, certains services peuvent être payants.

Article 3 : Services fournis par AgriConnect Africa

  AgriConnect Africa propose aux utilisateurs les services suivants :
- Accès aux prévisions agro-hydro-climatiques en langue locale : AgriConnect Africa fournit aux utilisateurs des informations sur les conditions et les risques météorologiques et climatiques ; les risques de sécheresse, d'inondation, d’envahissement par les ravageurs et de contamination par les virus. Ces informations sont basées sur des données probantes et des modèles prédictifs établis par les institutions spécialisées partenaires.
- Accès aux innovations et technologies d’agriculture intelligente face au climat : AgriConnect Africa diffuse aux utilisateurs des informations sur les dernières innovations et technologies résilientes face aux changements climatiques. Ces innovations et technologies sont présentées de manière simple et accessible dans la langue locale de l'utilisateur et sont  des travaux de recherches scientifiques des différents centres de recherche et laboratoires partenaires. Les informations dans ce cadre sont relatives aux nouvelles variétés, à la gestion de la fertilité des sols, à la gestion et à la maîtrise de l’eau, à la gestion des ravageurs et à la gestion des adventices entre autres. 
- Signalement des récoltes : AgriConnect Africa permet aux utilisateurs de signaler par messagerie audio, image et texte leurs prochaines récoltes et leurs stocks invendus. Elle pourrait ou non trouver des marchés d'écoulement plus rémunérateurs sans mise en relation directe avec l’acheteur, servant ainsi d'intermédiaire de vente. Ainsi, AgriConnect Africa facilite la communication, la négociation, la contractualisation et le paiement entre les utilisateurs et les acheteurs, et assure le suivi de la livraison des produits.
- Accompagnement technique pour une meilleure production : AgriConnect Africa permet aux utilisateurs de solliciter par messagerie audio, image et texte, son expertise en vue de répondre à des besoins spécifiques relatifs à leurs activités agricoles. Selon la spécificité de la sollicitation, l’utilisateur sera amené à payer les frais de prestations relatives.

Article 4 : Engagements des utilisateurs

  En contrepartie des services fournis par AgriConnect Africa, les utilisateurs s'engagent à :
- Recevoir les innovations dans leurs langues locales : les utilisateurs acceptent de recevoir les informations diffusées par AgriConnect Africa dans leur langue locale, ou dans une langue qu'ils comprennent.
- Annoncer les difficultés rencontrées : les utilisateurs s'engagent à signaler à AgriConnect Africa toute difficulté rencontrée dans l'utilisation des services, telle qu'une erreur, un dysfonctionnement, une incompréhension, une insatisfaction, etc ou dans la mise en oeuvre des informations fournis par AgriConnect Africa. Ce dernier s'efforcera de répondre aux demandes des utilisateurs dans les meilleurs délais et de leur apporter une solution adaptée.
- Signaler leurs récoltes : les utilisateurs s'engagent à informer AgriConnect Africa de leurs récoltes, en indiquant la quantité, la qualité, la variété, le prix et la disponibilité des produits. Ces informations permettent à AgriConnect Africa de proposer aux utilisateurs des opportunités de vente adaptées à leurs besoins et à leurs attentes.

Article 5 : Protection des données personnelles

  AgriConnect Africa respecte la vie privée des utilisateurs et s'engage à protéger leurs données personnelles qui lui sont fournies.
AgriConnect Africa collecte et traite les données personnelles des utilisateurs pour les finalités suivantes :
Gérer l'inscription, l'accès et l'utilisation de la plateforme ;
Fournir les services demandés par les utilisateurs ;
Améliorer la qualité et la performance de la plateforme et des services ;
Répondre aux questions, demandes et réclamations des utilisateurs ;
Envoyer aux utilisateurs des informations, des offres et des promotions sur les services de AgriConnect Africa ou de ses partenaires, sous réserve de leur consentement préalable.
AgriConnect Africa ne communique les données personnelles des utilisateurs qu'aux destinataires suivants :
Les sous-traitants et les prestataires de services de AgriConnect Africa, qui agissent sous son contrôle et selon ses instructions, pour les besoins du fonctionnement de la plateforme et des services ;
Les partenaires de AgriConnect Africa qui proposent des services complémentaires ou connexes à ceux de AgriConnect Africa, sous réserve du consentement préalable des utilisateurs ;
Les autorités administratives ou judiciaires, lorsque la loi l'exige ou l'autorise.
AgriConnect Africa conserve les données personnelles des utilisateurs pendant la durée nécessaire à la réalisation des finalités pour lesquelles elles ont été collectées, et au maximum pendant la durée de prescription légale applicable.
AgriConnect Africa met en œuvre les mesures techniques et organisationnelles appropriées pour garantir la sécurité, l'intégrité et la confidentialité des données personnelles des utilisateurs, et pour prévenir leur perte, leur altération, leur accès ou leur divulgation non autorisés.
Les utilisateurs disposent des droits suivants sur leurs données personnelles :
Droit d'accès : le droit de demander à AgriConnect Africa la confirmation que des données personnelles les concernant sont ou ne sont pas traitées, et, le cas échéant, d'obtenir l'accès à ces données et des informations sur leur traitement ;
Droit de rectification : le droit de demander à AgriConnect Africa la correction des données personnelles inexactes ou incomplètes les concernant ;
Droit à l'effacement : le droit de demander à AgriConnect Africa le nettoyage des données personnelles les concernant, lorsque ces données ne sont plus nécessaires, lorsque le consentement a été retiré, lorsque le traitement est contesté, lorsque le traitement est illicite ou lorsque la loi l'impose ;
Droit à la portabilité : le droit de demander à AgriConnect Africa de recevoir les données personnelles les concernant, dans un format structuré, couramment utilisé et lisible par machine, ou de les transmettre à un autre responsable du traitement, lorsque le traitement est fondé sur le consentement ou sur un contrat, et qu'il est effectué à l'aide de procédés automatisés ;
Droit d'opposition : le droit de s'opposer à tout moment, pour des raisons tenant à leur situation particulière, au traitement des données personnelles les concernant, lorsque le traitement est fondé sur l'intérêt légitime de AgriConnect Africa ou sur l'exécution d'une mission d'intérêt public ou relevant de l'exercice de l'autorité publique, sauf si AgriConnect Africa démontre qu'il existe des motifs légitimes et impérieux pour le traitement qui prévalent sur les intérêts et les droits et libertés des utilisateurs, ou pour la constatation, l'exercice ou la défense de droits en justice ;
Droit de retirer son consentement : le droit de retirer à tout moment le consentement donné pour le traitement des données personnelles les concernant, sans que cela ne porte atteinte à la licéité du traitement fondé sur le consentement effectué avant le retrait de celui-ci ;
Droit d'introduire une réclamation : le droit d'introduire une réclamation auprès de l'autorité de contrôle compétente en matière de protection des données personnelles, si les utilisateurs estiment que le traitement de leurs données personnelles constitue une violation de la réglementation applicable.
Les utilisateurs peuvent exercer leurs droits en contactant AgriConnect Africa par e-mail à l'adresse digitalfarmafrica@gmail.com , ou via le +229 53 19 78 81 (Appel, Whatsapp et SMS).

Article 6 : Propriété intellectuelle

  Digital Farm Afrik est le titulaire exclusif de tous les droits de propriété intellectuelle portant sur la plateforme, les services, les contenus, les données, les logos, les marques, les noms de domaine, les logiciels, les bases de données, les codes sources, les designs, les graphismes, les images, les sons, les vidéos, les animations, les interfaces, les fonctionnalités, etc.
Les utilisateurs reconnaissent que l'accès et l'utilisation de la plateforme et des services ne leur confèrent aucun droit de propriété intellectuelle sur ces éléments, et qu'ils ne peuvent les reproduire, représenter, modifier, adapter, traduire, transmettre, diffuser, exploiter, commercialiser ou céder à des tiers, sans l'autorisation préalable et écrite de Digital Farm Afrik.
Les utilisateurs s'engagent à respecter les droits de propriété intellectuelle de Digital Farm Afrik et de ses partenaires, et à ne pas porter atteinte à ces droits, directement ou indirectement, par quelque moyen que ce soit.

Article 7 : Responsabilité

  Digital Farm Afrik s'engage à fournir les services avec diligence et professionnalisme, dans le respect des règles de l'art et des normes applicables.
Digital Farm Afrik ne peut être tenu responsable des dommages directs ou indirects, matériels ou immatériels, causés aux utilisateurs ou à des tiers, du fait de l'accès ou de l'utilisation de la plateforme ou des services, ou de leur indisponibilité, sauf en cas de faute lourde ou intentionnelle de sa part.
Digital Farm Afrik ne peut être tenu responsable des contenus, des informations, des offres, des produits ou des services proposés par des tiers sur la plateforme ou via des liens hypertextes, ni des transactions ou des litiges qui pourraient survenir entre les utilisateurs et ces tiers.
Digital Farm Afrik ne peut être tenu responsable du non-respect par les utilisateurs des présentes CGU, ni des conséquences qui pourraient en découler pour eux ou pour des tiers.
Les utilisateurs sont responsables de l'accès et de l'utilisation de la plateforme et des services, ainsi que des données qu'ils fournissent ou qu'ils reçoivent.
Les utilisateurs s'engagent à utiliser la plateforme et les services de manière loyale, licite et respectueuse des droits et des intérêts de Digital Farm Afrik et des tiers.
Les utilisateurs s'engagent à ne pas utiliser la plateforme et les services à des fins illicites, frauduleuses, malveillantes, nuisibles, offensantes, diffamatoires, injurieuses, obscènes, racistes, discriminatoires, menaçantes, harcelantes, violentes, pornographiques ou contraires à l'ordre public ou aux bonnes mœurs.
Les utilisateurs s'engagent à ne pas porter atteinte à la sécurité, à l'intégrité ou au fonctionnement de la plateforme et des services, ni à introduire ou à propager des virus, des logiciels malveillants, des chevaux de Troie, des vers, des bombes logiques ou tout autre élément nuisible.
Les utilisateurs s'engagent à ne pas accéder ou tenter d'accéder sans autorisation à des données, des systèmes, des réseaux ou des comptes d'autres utilisateurs ou de tiers, ni à interférer ou perturber le fonctionnement de la plateforme ou des services.
Les utilisateurs s'engagent à indemniser Digital Farm Afrik de tout préjudice, toute perte, tout dommage, toute responsabilité, toute sanction, tout coût ou toute dépense, y compris les frais de justice, résultant du non-respect par les utilisateurs des présentes CGU ou des droits de Digital Farm Afrik ou de tiers.

Article 8 : Résiliation

  Les utilisateurs peuvent résilier leur inscription sur la plateforme à tout moment en utilisant la fonctionnalité prévue à cet effet sur la plateforme.
AgriConnect Africa peut résilier l'inscription d'un utilisateur sur la plateforme, sans préavis ni indemnité, en cas de manquement grave ou répété aux présentes CGU, ou pour des raisons techniques, juridiques ou de sécurité.
La résiliation de l'inscription entraîne la suppression du compte de l'utilisateur, ainsi que de ses données personnelles, sauf si la loi impose à AgriConnect Africa de les conserver.

Article 9 : Modification des CGU

  AgriConnect Africa se réserve le droit de modifier les présentes CGU à tout moment, en fonction de l'évolution de la plateforme, des services, de la réglementation ou de ses besoins.
Les utilisateurs seront informés de toute modification des CGU par e-mail ou par notification sur la plateforme, au moins quinze (15) jours avant leur entrée en vigueur.
Les utilisateurs qui n'acceptent pas les CGU modifiées peuvent résilier leur inscription sur la plateforme, conformément à l'article 8.
Les utilisateurs qui continuent à utiliser la plateforme et les services après l'entrée en vigueur des CGU modifiées sont réputés avoir accepté ces modifications.

Article 10 : Loi applicable et règlement des litiges

  Les présentes CGU sont soumises au droit béninois.
En cas de litige relatif à l'interprétation, à l'exécution ou à la validité des présentes CGU, les parties s'efforceront de le résoudre à l'amiable, par voie de médiation ou de conciliation.
À défaut de règlement amiable, le litige sera soumis au tribunal de 1ère classe d’Abomey-Calavi.
''';



    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Politiquede confidentialité',
            style: GoogleFonts.kadwa(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          //backgroundColor: Colors.transparent,
          backgroundColor: PRIMARY_COLOR,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.centerRight,
                        stops: const [
                      0.1,
                      0.5,
                      0.9
                    ],
                        colors: [
                      Colors.greenAccent,
                      const Color.fromARGB(255, 104, 255, 109).withOpacity(.5),
                      Colors.white
                    ])),
                child: Opacity(
                  opacity: _opacity.value,
                  child: Transform.scale(
                    scale: _transform.value,
                    child: Container(
        
                      width: size.width * .94,
                      height: size.height * 1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        /*boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            blurRadius: 40,
                          ),
                        ],*/
                      ),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: 200,
                                    height: 80,
                                    //color: Colors.red,
                                    child: Image.asset(
                                      "images/agri.png",
                                      fit: BoxFit.cover,
                                    )),
        
                                Container(
                                  width: size.width*0.9,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
        
                                      children: [
                                      Text(
                                      title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
        
                                      ),
                                    ),
                                        Text(
                                          politiqueDeConfidentialite,
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.kadwa(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isClick,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            widget.isRead = !widget.isRead;
                                            isClick = !isClick;
                                          });
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Lu et approuvé',
                                      style: GoogleFonts.kadwa(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      PolitiqueEtConfidantialite(isRead: isClick).isRead = isClick;
                                      print('Valeur de isRead' + '${PolitiqueEtConfidantialite(isRead: isClick).isRead}');
                                      Get.back();
                                    });
                                  },

                                  child: component2('Valider', 1, () {
                                    if (isClick) {
                                      print('Yes valider');
                                      setState(() {
                                        //PolitiqueEtConfidantialite(isRead: isClick).isRead = isClick;

                                        print('Valeur de isRead' + '${PolitiqueEtConfidantialite(isRead: isClick).isRead}');
                                        Get.back();
                                      });
                                    } else {
                                      _showSnackBar(
                                          'Veillez crocher l\'option lu et approuvé');
                                    }
                                  }),
                                ),
                                const SizedBox(
                                  height: 100,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget component2(String string, double width, VoidCallback voidCallback) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: voidCallback,
      child: Container(
        height: size.width / 8,
        width: size.width / width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.1, 0.5],
                colors: [PRIMARY_COLOR, PRIMARY_COLOR.withOpacity(.5)])),
        child: Text(
          string,
          style: GoogleFonts.kadwa(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /* signin() {
    setState(() {
      inlogin = true;
      AuthService().signInWithGoogle();
    });
  }
 */

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PRIMARY_COLOR,
        content: Text(message),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
