 <div align="justify"> **Titlul proiectului**: STIMIA

**Autorii**: echipa STIMIA - Măgirescu Sofia Maria, Gavriliu Călin-Petru
 
**Coordonator**:
	Întuneric Ana, profesor de informatică, Colegiul Național „Ferdinand I” Bacău
 
**Secțiunea**: 
	Software educațional


# Descrierea proiectului:

„STIMIA” este un soft educațional care îl ajută pe utilizator să se cunoască mai bine și să evolueze din punct de vedere emoțional și senzorial, contribuind semnificativ la starea de bine și la modul în care el înțelege lumea din jur. Utilizatorul are acces la conținut educațional personalizat creat de specialiști din domeniul psihologiei, lecții video, dar și scrise, pentru a putea reține informațiile importante despre emoții, stări, hipo-activare, hiper-activare, expunerea senzorială etc. Prin activități și provocări personalizate, printr-un asistent virtual cu inteligență artificială și printr-un jurnal digital care se completează automat, utilizatorul își poate urmări evoluția și, treptat, prin formarea obiceiurilor pe care aplicația le promovează, ajunge să se înțeleagă mai bine pe sine și să fie echilibrat, învățând să fie atent la modul în care se simte și în raport cu lumea din jur. Softul este bazat pe metoda de învățare „Kata”, inspirată din practicile și filozofia „Lean” dezvoltate în Japonia, care pune accent pe învățare prin formarea de obiceiuri, ceea ce înseamnă că utilizatorul nu va fi epuizat, iar ce învață va rămâne pe termen lung. Doza zilnică de activități în aplicație îl face pe utilizator să fie interesat și să nu se plictisească, mergând pe principiul „câte puțin în fiecare zi”.

# Mod de funcționare:
Utilizatorul deschide aplicația. Pe ecranul principal primește un citat care să îl motiveze și la care să se gândească pe parcusul zilei. Pe pagina principală utilizatorul are posibilitatea de a apăsa butonul principal „Începe doza zilnică”, ce îl va conduce pe traseul educațional din ziua respectivă ori butoanele „Acasă” (îl întoarce la pagina principală), „Provocarea zilei”, „Sfaturile lui Stivie”, „Lecția de astăzi”, „Activitate”, acolo unde își poate observa evoluția.
Apăsând butonul „Începe doza zilnică”, utilizatorul începe „sesiunea de lucru” în care toate răspunsuile pe care le dă vor fi resurse pentru construirea traseului personalizat:
1.	Este întrebat cum s-a simțit în ziua respectivă până în acel moment, având posibilitatea de a selecta mai multe stări.
2.	Este întrebat care sunt lucrurile care au contribuit la stările sufletești trăite, având posibilitatea de a selecta mai multe opțiuni.
3.	Este condus spre o conversație scurtă cu asistentul virtual Stivie, acolo unde utilizatorul este întrebat detalii despre felul în care simte, dar poate iniția și el discuții, cerând sfaturi despre cum ar putea să își îmbunătățească starea sau ce ar putea să facă în anumite situații. În momentul în care conversația se apropie de sfârșit, apare butonul „Finalizează sesiunea”, care va duce la următorul pas.
4.	Apare un mini-quiz care îl va face pe utilizator să înțeleagă mai multe lucruri despre sine, dar va fi și de ajutor în propunerea următorilor pași.
5.	Utilizatorul primește lecția zilei, unde va afla mai multe despre un subiect potrivit stării lui din ziua respectivă, dar și activității precedente.
6.	Apare provocarea zilei care poate fi completată pe loc sau mai târziu, urmând să fie verificată îndeplinirea ei prin text (conversație cu asistentul virtual Stivie), imagini (detectare de obiecte) sau număr de pași (verificare sistem de sănătate din telefon).
Provocarea și lecția zilei pot fi accesate oricând de pe pagina principală cu scopul de a fi completate sau urmărite.
La sfârșitul sesiunii de lucru, pagina de jurnal se completează automat, făcând un rezumat al activității, toate aceste pagini putând fi urmărite în secțiunea „Activitate”. Acolo se pot observa și grafice de evoluție în funcție de mai multe date, dar și progresul în funcție de culori.

## I.	Arhitectura aplicației

### I.1. – Tehnologii folosite
- Front-end:
Xcode / SwiftUI (Utilizate pentru dezvoltarea interfeței grafice și a funcționalităților de bază ale aplicației educaționale.);
Adobe Illustrator (Folosit pentru crearea elementelor grafice vectoriale personalizate, precum iconițe, logoul, emoticoane etc.);
Adobe Photoshop (Utilizat pentru editarea și optimizarea imaginilor și a materialelor grafice.);
Adobe Animate (Folosit pentru crearea animațiilor interactive care îmbunătățesc experiența de învățare.);
Adobe XD (Utilizat pentru prototiparea și designul interfeței aplicației.);
HTML (Folosit pentru structurarea conținutului web al provocărilor.);
CSS (Utilizat pentru stilizarea și prezentarea vizuală a provocărilor.);
JavaScript (Folosit pentru adăugarea funcționalităților dinamice și interactive ale provocărilor.);
- Back-end:
SwiftData (Folosit la nivel local pentru gestionarea și stocarea datelor sensibile și private ale utilizatorului.);
CloudKit (Utilizat pentru stocarea și sincronizarea datelor în cloud, orice schimbare fiind reflectată în timp real pe toate dispozitivele cu același cont de iCloud.);
Firebase (Folosit pentru atât pentru stocarea conținutului educațional, de pildă videouri, articole, cât și pentru notificări push.);
CoreML / CreateML (Folosite pentru antrenarea, implementarea și rularea machine learning-ului, cum ar fi recunoașterea obiectelor și a culorilor.);
- API-uri:
OpenAI API (Utilizat pentru integrarea funcționalităților avansate de procesare a limbajului natural, ce iau viață sub forma asistentului nostru virtual, Stivie.);
HealthKit (Folosit pentru monitorizarea și gestionarea datelor de activitate fizică, necesar pentru provocări.);
Apple Screentime / Device Activity (Utilizat pentru monitorizarea timpului petrecut pe dispozitiv în scopuri educaționale, necesar pentru provocări.);

### I.2. – Proiectarea arhitecturală

Încă de când ne-a venit ideea proiectului, am ales să  utilizăm pentru gestionarea și crearea aplicației STIMIA platforma Xcode, software profesional, standardul industrial pentru aplicații pe iOS, macOS, watchOS etc. Deși este o platformă în care se poate lucra în toate limbajele de programare, Xcode găzduiește tot ecosistemul Swift, un sistem robust de tehnologii care ne ajută să atingem toate obiectivele propuse cu acest proiect: limbajul Swift (cod de bază), framework-ul SwiftUI (interfață, animații, navigație, interacțiune vizuală între ecrane), SwiftData (construit pe tehnologia de încredere Core Data, ce oferă metode de gestionare eficientă a informațiile sensibile și stocare automată în SQLite), AVKit (afișarea video și audio), CoreML (API ce facilitează integrarea modelelor de machine learning în aplicație, fără a solicita multe resurse), Swift Charts, UIKit, WebKit.

Pentru a asigura o experiență calitativă în utilizarea aplicației, lipsită de bug-uri și imperfecțiuni, am început prin proiectarea și crearea funcțiilor de bază în „mini-aplicații”. Avantaje: fiecare funcționalitate a fost izolată; bug-uri mai ușor de detectat și rezolvat; schimbări minore și majore ușor de implementat; feedback primit și concretizat rapid. Exemplu: am început cu crearea asistentului virtual Stivie (funcționalitate principală a softului nostru) și am colectat eficient feedback despre interacțiunea lui cu utilizatorii, astfel că ne-am concentrat pe antrenarea lui spre a-i forma un limbaj cât mai natural și potrivit. Deoarece am lucrat pe fiecare segment în parte, am primit feedback rapid de la psihologi care ne-au sugerat ca asistentul virtual să nu devină prietenul elevului. Am avut grijă să menținem un echilibru între prietenie și robotizare, pentru ca utilizatorul să nu se atașeze de Stivie, să nu găsească în el un prieten, ci doar un sprijin, un asistent care îndrumă în călătoria de creștere, tocmai pentru că scopul aplicației este să îi deschidă tânărului perspective asupra împrietenirii în viața reală, nu în mediul virtual. 

Componente izolate pentru creare: 
-	Asistentul virtual Stivie
-	Pagina de jurnal care se completează automat
-	Quiz-ul zilnic
-	AppleHealthKit integrat în aplicație pentru numărarea pașilor 
-	Testarea provoărilor
-	Elemente grafice și background-uri abstract
-	Etc.

După construirea eficientă a funcționalităților de bază, le-am unit într-o aplicație coerentă pe care am perfecționat-o atât din perspectiva back-end, cât și front-end, aducând proiectul nostru într-un stadiu în care poate fi distribuit publicului.
Mai departe, am vrut să găsim un sistem care să aibă atât viteză ridicată adusă de stocarea la nivel local, cât și beneficii pentru utilizator, pentru ca el să nu facă de fiecare dată update când actualizăm conținutul educațional. Prin urmare, am utilizat Firebase Realtime Database, ca să gestionăm toate informațiile publice, astfel încât să poată fi actualizate eficient, rapid și ușor.
Pentru stocarea link-urilor, am ales Firebase, întrucât durează foarte puțin. Pentru stocarea video-urilor, am încărcat pe un server de test cu acces securizat pe protocolul FTP.
SwiftUi și AVKit transformă rapid link-ul în video, ca fie stocat local temporar, pentru o experiență cât mai fluidă pe aplicație.
Am utilizat framework-ul CloudKit pentru a stoca în serverele iCloud informații sensibile, fiind păstrate în siguranță. Pe lângă benmeficiile de Securitate, iCloud oferă posibilitatea de a sări peste pasul de logare și de a sincroniza în timp real datele pe toate dispozitivele.

Întrucat ne-am propus să scriem un cod cât mai elegant și curat, am ales câteva tehnici de programare specifice, printre care se numară și pattern-ul de design MVVM (Model – View – ViewModel). Astfel, în ciuda faptului că aplicația este, în mare parte, scrisă în același limbaj (Swift), granița dintre logică și interfață este una clară și bine determinată. În SwiftUI, Modelul gestionează datele și logica, ViewModelul servește ca un intermediar care expune datele și logica de prezentare pentru View, iar View-ul prezintă interfața utilizatorului și reacționează la modificările din ViewModel. Aceasta separație ajută la organizarea codului într-un mod modular, ușor de testat și întreținut, permițând reutilizarea și testabilitatea componentelor. În codul sursă veți întâlni des acest pattern, câteva exemple fiind:
-	JournalEntry (Model) – EntryView (View) – JournalEntryViewModel (ViewModel), fiecare având rolul său distinct de a stoca datele utilizatorului cu SwiftData, în iCloud; de a afișa datele pe o interfață cu aspect plăcut și hiper-personalizat; de a stoca funcțiile ce permit colaborarea între front-end și back-end (cum ar fi salvarea imaginilor sau recomandarea conținutului educațional în funcție de context și de nevoile utilizatorului) respective
-	Challenge, Lesson, QuizQuestion, Quotes (Model) – JournalView și, în mare parte, restul aplicației (View) – FirebaseViewModel (ViewModel), acestea asigurând o integrare eficientă și organizată între Swift și Firebase
-	ChatMessageModel (Model) – ChatView (View) – OpenAIService (ViewModel)
-	etc.
Mai mult, fiecare componentă de UI ce se repetă cu mici modificări în toată aplicația este view reutilizabil. Am definit parametri flexibili pentru aceste view-uri, permițându-le să fie personalizate în funcție de contextul în care erau folosite. De exemplu, Card-urile cu provocări și conținut educațional sunt scrise doar o singură dată și necesită specificarea unor parametri la momentul invocării, utilizând, astfel, același view în ecranul principal „Acasă”, pagini de jurnal și interfață în momentul învățării. Avantajele acestei practici sunt evidente și includ, dar nu se limitează la, repararea mai ușoară a bug-urilor, eliminarea problemelor neașteptate cauzate de inevitabilele erori de copy-paste și obținerea unui UI mai consistent în ansamblu.

### I.3. – Portabilitate
Proiectul poate fi rulat pe mai multe dispozitive, rezoluția și ecranul fiind adaptate tuturor dimensiunilor și cerințelor de sistem. Aplicația poate fi deschisă de pe PC, laptop, tabletă și telefon.

## II.	Implementarea aplicației

### II.1. – Eleganța implementării
În ceea ce privește limbajul de programare, am folosit Swift și am putut face corespondența ușor între fișiere și framework-uri. Astfel, pentru a avea un control mai mare asupra codului, am ales să izolăm funcționalitățile proiectului și să le facem să funcționeze, urmând să le unim apoi în aplicația mare.

Pentru antrenarea și implementarea asistentului virtual Stivie, am apelat la mai multe funcții și am implementat numeroase promt-uri de antrenare cât mai corect și logic. Creat pe parcursul a două luni de testare și colectare constantă de feedback, sistemul nostru de prompt-uri permite o experiență lipsită total de impedimente și dificultăți create de inteligența artificială. Asistentul ține minte și respectă contextul conversației, oferă răspunsuri personalizate ținând cont de emoțiile înregistrate de utilizator și de factorii ce le-au cauzat, nu deviază de la subiect, respectă instrucțiunile date de sistem întocmai, are un mod de a vorbi neașteptat de uman și dă sfaturi valoroase în legatură cu orice îi cere utilizatorul, atât timp cât are legatură cu domeniul dezvoltării personale. Din punct de vedere al tonului și al relației între asistent și utilizator, Stivie este mereu într-o ,,zonă Goldilocks” (potrivită), nici străin, nici prieten apropiat, ci doar un asistent dornic de a-l ajuta pe utilizator să-și consolideze obiceiuri noi, întrucât scopul lui este de a crea un mediu ,,safe” cu ajutorul căruia se cunoaște pe el însuși mai bine și înțelege fenomenele sociale și psihologice, nu de a-l izola mai mult de societate prin crearea unui prieten inexistent.

Pentru a avea cât mai mult control asupra asistentului, nu ne-am limitat la un un singur șir de text cu instrucțiuni, ci am creat o rețea de prompt-uri, care funcționează, în mare parte, astfel:
-	Instrucțiuni abstracte de inițializare: 
1. După ce utilizatorul alege emoțiile simțite pe tot parcursul zilei respective, aceste informații, alături de numele și prenumele lui, contextul conversației trecute și întrebări despre activitatea din ziua de dinainte sunt transmise modelului de ChatGPT 4o.
2. Se specifică rolul lui în această conversație – Un asistent virtual trebuie să ajute utilizatorul să își înțeleagă mai bine sentimentele și să proceseze cauzele stării lui actuale, oferindu-i sfaturi și soluții.
3. Se precizează cum își va împlini rolul – Asistentul trebuie să pună întrebări scurte și direcționate, să folosească cuvinte de încurajare calde și să păstreze un ton prietenos și înțelegător. Dacă utilizatorul întreabă ceva nelegat de dezvoltare personală, asistentul trebuie să refuze politicos să răspundă. Conversația trebuie să fie fluidă, iar asistentul să nu facă presupuneri, ci să se bazeze pe ceea ce spune utilizatorul.
-	Instrucțiuni tehnice de inițializare:
1. Se specifică limita de token-uri.
2. Se precizează cum ar trebui să fie stilizat textul (de pildă, marcarea unei liste cu @LIST@), pentru a fi posibil algoritmul de transformare a textului generat de asistent într-un model personalizat. Aceste modele au mai multe forme, printre care se numară un dicționar de liste de sfaturi, care pot fi stocate în pagina de jurnal a zilei, sau subiecte de discuție pentru sesiunea următoare.
-	Instrucțiuni de generare a textului paginii de jurnal, scrisă la persoana întâi, pe baza conversației avute.
-	Instrucțiuni de generare a întrebărilor și subiectelor de discuție pentru data viitoare, pentru a umple goluri și a se pune în lumină evoluția constantă a utilizatorului.

În afară de OpenAI, STIMIA utilizează și alte tehnologii, de exemplu CoreML și CreateML.
Mai ales pentru persoanele hipo-activate, provocările recomandate încurajează ieșirea utilizatorului în natură. Pentru a verifica dacă utilizatorul chiar a stat afară sau nu, conditia pentru finalizarea provocării este încărcarea a 5 poze cu natura, punându-se accent într-o zi pe flori, în alta pe copaci și așa mai departe. Așadar, pentru a crea un model de clasificare a imaginilor care să diferențieze între poze cu natură și non-poze cu natură, am utilizat Create ML și Core ML, două tehnologii puternice dezvoltate de Apple. Procesul a început cu colectarea datelor de pe platforma Kaggle, unde am găsit un set de date cu imagini etichetate în cele două categorii de interes. Am descărcat și organizat aceste imagini în foldere separate pentru fiecare categorie, pregătindu-le pentru preprocesare.
Preprocesarea datelor a fost un pas crucial pentru a asigura calitatea și consistența imaginilor utilizate pentru antrenare. Am redimensionat toate imaginile la o dimensiune uniformă de 224x224 pixeli și am aplicat normalizarea pixelilor pentru a uniformiza valorile intensității culorilor. De asemenea, am folosit tehnici de augmentare a datelor, cum ar fi rotația, zoom-ul și flip-ul orizontal, pentru a îmbunătăți diversitatea setului de antrenament și a preveni supraînvățarea modelului.
Pentru antrenarea modelului, am folosit Create ML, un instrument integrat în Xcode care facilitează crearea modelelor de machine learning printr-o interfață grafică intuitivă. Am selectat template-ul de clasificare a imaginilor și am importat setul de date preprocesat. Create ML a automatizat divizarea datelor în seturi de antrenament și testare, asigurând o evaluare corespunzătoare a performanței modelului. Antrenarea modelului a implicat utilizarea unei rețele neuronale convoluționale (CNN), optimizată pentru clasificarea imaginilor. Create ML a gestionat automat ajustarea hiperparametrilor și a efectuat validarea încrucișată pentru a maximiza acuratețea modelului.
După finalizarea antrenamentului, am obținut un fișier Core ML (.mlmodel) care conține modelul antrenat. Acest fișier include toate metadatele necesare, cum ar fi schema de intrare și ieșire a datelor, precum și parametrii modelului. Implementarea modelului în SwiftUI a fost realizată prin integrarea fișierului Core ML folosind API-ul Core ML oferit de Apple. Am creat un wrapper pentru model, permițând aplicației să trimită imagini către model și să primească predicții în timp real.
Pentru a gestiona fluxul de date asincron și a actualiza UI-ul aplicației în funcție de predicțiile modelului, am folosit framework-ul Combine. De asemenea, am efectuat profiling-ul aplicației folosind instrumente pentru a identifica și elimina eventualele limite de performanță în ceea ce privește viteza, asigurând astfel o experiență de utilizare rapidă, chiar și pe dispozitive cu resurse limitate.

Mai mult, pentru a ține cont de zilele în care utilizatorul hipo-activat iese afară, se recomandă și provocări ce țin de numărul de pași în ziua respectivă. Prin urmare, am apelat la Apple HealthKit, iar prin pattern-ul MVVM, se determină pașii necesari pentru a completa provocarea (media aritmetică a pașilor din ultima săptămâna, rotunjită, plus 500) și se verifică dacă utilizatorul a depășit numărul de pași propus sau nu. Astfel, încetul cu încetul, se consolidează obiceiul de a ieși afară și de a face mișcare fizică, lucru ce s-a dovedit din nou și din nou că are un impact major asupra sănătății mintale.

### II.2. – Testarea aplicației
Pentru a atinge standardele înalte de securitate întemeiate de Apple, fiecare aplicație proiectată pentru iOS și MacOS poate fi testată doar în două modalități:
1.	prin acces direct la codul sursă și instalarea acestuia pe un dispozitiv prin intermediul software-ului Xcode;
2.	prin încărcarea pe platforma de beta testing creată de Apple, numită TestFlight (care durează între 2 zile și o săptămână pentru fiecare versiune a aplicației. Ultima versiune va fi disponibilă imediat ce este verificată și aprobată de un specialist Apple).

În perioada alfa de testare, am încărcat manual pe dispoziivele prietenilor, apropiaților, colegilor și elevilor din școală, pentru a observa cum funcționează funcțiile de bază (asistentul virtual Stivie, pagina de jurnal care se completează automat și diverse activități). În faza inițială, aveam proiectate jocuri de brain-training, dar nu au fost atât de bine primite, astfel că ne-am reproiectat softul, pentru a fi cât mai atractiv, interesant, captivant. Ulterior, am primit feedback pozitiv în ceea ce privește modificările făcute atât de la elevi, cât și de la psihologii cu care am colaborat și care au verificat și testat constant conținutul aplicației și efectele pe care le are.

În același timp, am testat direct aplicația pentru a observa bug-urile minore. Pentru asta, am folosit simulatoarele care se instalează automat în pachetul Xcode. Astfel, observat în timp real evoluția codului și felul în care aplicația se comportă pe iPhone, iPad, Mac, dar aplicația poate fi extinsă și pe Apple Watch, Apple TV și Apple Vision. Am utilizat simulatorul și nu un dispozitiv de testare extern, pentru a putea încărca și observa mult mai rapid versiunile noi, pentru a modifica eficient codul și pentru a vedea cum arăta aplicația pe diferite rezoluții, în medii diferite (dark/light mode, mărimi de text, aspect ratio).

### II.3. – Folosirea unui sistem de gestionare a codului
Pentru a putea gestiona eficient codul și proiectul, am utilizat GitHub, unde am încărcat și am lucrat simultan și Trello, unde am stabilit clar ideile și direcția pe care vom merge cu lucrarea.

### II.4. – Maturitatea aplicației
Stadiul actual al proiectului este accesibil utilizatorilor și oferă toate funcționalitățile pe care ni le-am propus. Totuși, avem de gând să desvoltăm aplicația mai departe, adăugând noi funcții.
Pentru a avea un control mai mare asupra codului, am ales să izolăm componentele proiectului și să le facem să funcționeze. Am reușit, astfel, să fixăm bug-uri și să ne asigurăm de eficiența fiecărui segment de cod. După construirea eficientă a funcționalităților de bază, le-am unit într-o aplicație coerentă pe care am perfecționat-o atât din perspectiva back-end, cât și front-end, aducând proiectul nostru într-un stadiu în care poate fi distribuit publicului. 

### II.5. – Securitatea aplicației
Pentru a gestiona și a stoca datele sensibile și private ale utilizatorilor, am folosit SwiftData, tehnologie de ultimă generație, construită pe fundația Core Data, un framework robust și extensibil utilizat pentru gestionarea persistentă a obiectelor de model în iOS și macOS, oferind un set comprehensiv de API-uri pentru operațiuni CRUD (Create, Read, Update, Delete) asupra datelor. Pentru stocarea persistentă a datelor gestionate de Core Data am utilizat SQLite, fără a necesita un server de baze de date separate pentru informații sensibile. Mai mult, am folosit CloudKit, pentru sincronizarea acelor date între toate dispozitivele cu același cont de iCloud, informațiile fiind actualizate peste tot în timp real. Chiar dacă utilizatorul își dă consimțământul pentru prelucrarea datelor în iCloud, informațiile sunt stocate doar în serverele Apple, sunt end-to-end encrypted și nimeni, nici noi, nici Apple, nu are acces la ele.

Un alt beneficiu al utilizării CloudKit este evitarea procesului de logare, ceea ce este o situație win-win atât pentru utilizator, cât și pentru noi:
-	Utilizatorul are acces imediat în aplicație, fără furnizeze și să își aducă aminte datele de fiecare data când vrea să intre în aplicație.
-	Noi, creatorii aplicației, facem legătura pasiv dintre fiecare utilizator și traseul personalizat propus de aplicație.

## III.	Interfață

### III.1. – Impresia generală
Toate animațiile și grafica aplicației au fost create de noi în Adobe Creative Cloud (Photoshop, Animate, XD, Illustrator), toate desenele fiind sub formă vectorială.
Rezoluția ecranului se modifică automat în funcție de dimensiunile dispozitivelor, aplicația fiind accesibilă și compatibilă indiferent de cerințele dispozitivului.

### III.2. – Ușurința în folosire
Proiectul are o interfață intuitivă, ușor de parcurs, utilizatorul fiind ghidat de asistentul virtual Stivie prin pașii de urmat în aplicație. De asemenea, am pus la dispoziția utilizatorului butoane ajutătoare care fac aplicația ușor de utilizat, dar am integrat și funcții de swipe, specifice categoriei de oameni cărora proiectul se adresează, tinerii și elevii, întrucât sunt îndrăgite și accesibile pentru ei.

## IV.	Conținut

### IV.1. – Funcționalitate, utilitate și interactivitate
În contextul în care majoritatea tinerilor și adolescenților, cei care formează Generația Z, se confruntă cu dificultăți în recunoașterea și gestionarea emoțiilor, am vrut să cream o aplicație care să îi facă să înțeleagă despre sentimentele și stările proprii, însă fără a părea că livrăm doar informații. Încă de la prima utilizare a aplicației, utilizatorul își construiește cu ajutorul asistentului virtual Stivie propriul traseu personalizat de urma, în vederea unui echilibru emoțional și senzorial. Deși tehnologia, prin social media și nu doar, este cea care i-a îndepărtat pe tineri de propriile emoții prin livrarea unor mesaje eronate despre cum ar trebui să se simtă și să reacționeze, proiectul STIMIA nu promovează petrecerea unui timp îndelungat pe dispozitive electronice. Prin lecțiile și provocările din aplicație, utilizatorul învață despre cum să mențină echilibrul telefon-viață și este îndemnat să petreacă timp cu sine și cu ceilalți, pentru a se conecta cu lumea din jur.
Aplicația are ca scop educarea utilizatorului cu privire la propria persoană: stări, sentimente, emoții, cauzele lor, dar și consecințele, felul în care ele reflectă trăirile omului. Provocările și activitățile propuse urmăresc să îl facă pe utilizator să intre în contact cu lumea din jur, dar și să ajungă la un echilibru al propriei persoane, la o stare armonioasă din punct de vedere emoțional și sensorial.
Mai mult decât atât, am integrat în aplicație un jurnal digital care înregistrează și reține evoluția și progresul utilizatorului. Omul accesează aplicația și face „doza zilnică”, adică ceea ce îi propune traseul personalizat, în vreme ce activitatea sa este stocată în jurnalul personal. 

### IV.2. – Evaluare și feedback
În fiecare zi utlizatorul este întrebat despre gândurile sale, stări, emoții și, în funcție de aceste date și de cele din zilele precedente, îi este recomandat un traseu personalizat de urmat. În fiecare zi, este evaluată provocarea pe care a avut-o de îndeplinit și felul în care ea a avut un impact asupra omului. Rezultatele sunt comparate cu cele din zilele precedente și se oferă feedback.
Aplicația nu promovează ideea de greșit sau corect, ci pune accent pe traseul de evoluție al fiecărui utilizator, pentru că este o experiență despre creștere emoțională și senzorială.

### IV.3. – Posibilitatea de a actualiza și gestiona conținutul 
Conținutul educațional (provocări, lecții interactive, video-uri, articole) este stocat pe Firebase, platformă de dezvoltare de la Google care oferă un set integrat de instrumente și servicii pentru diferite tipuri de aplicații. Utilizând baze de date NoSQL, numit Firebase Realtime Database, gestionăm toate aceste informații publice, astfel încât să poată fi actualizate eficient, rapid și ușor.
Lecțiile video sunt încărcate pe un server de test cu acces securizat pe protocolul FTP, link-urile lor fiind stocate în Firebase Realtime Database și sunt accesate în aplicație cu aceeași viteză ca un video stocat local, însă permite modificarea în timp real a conținutului educațional, fără a necesita un update al aplicației STIMIA, în AppStore sau TestFlight.

### IV.4. – Corectitudinea informațiilor din punct de vedere științific 
Aducem utilizatorului conținut educațional personalizat creat cu îndrumarea specialiștilor din domeniul psihologiei: lecții video, dar și scrise (articole), provocări și activități.

## V.	Originalitate și inovație

### V.1. – Originalitatea ideii sau inovații aduse față de soluții existente
Proiectul nostru este original și aduce o altă perspectivă asupra modului în care tinerii pot învăța despre emoțiile lor. Softul este bazat pe metoda de învățare „Kata”, inspirată din practicile și filozofia „Lean” dezvoltate în Japonia, punând accent pe formarea obiceiurilor. Astfel, utilizatorul învață, treptat, despre modul în care se poate conecta cu lumea din jur și în care se poate simți mai bine, chiar și atunci când pare să nu fie.
</div>
