#!/bin/bash

#____________________________________________________________
#Chemin du serveur à lancer
spigotJarPath="/home/ServeursMinecraft/Serveur_1/spigot-1.12.2.jar"
#Commande de lancement Java
commandeJava="java -jar -Xms256M -Xmx1024M"
commandeJavaEnd="nogui"
#Nom de l'archive dans la date
archiveName="Serveur_1"
#Dossier à sauvegarder
dossierASauvegarderFullPath="/home/ServeursMinecraft/Serveur_1"
#Dossier cible des archives
backupDirectory="/home/ServeursMinecraft/Server-Backup/Serveur_1"
#Relancer le serveur si éteint
looping=true
#Attendre avant de lancer le serveur
attendre=true
#Activation de la sauvegarde après extinction
saveEnabled=false
# Plage horaire de la sauvegarde:
heureDebut=05
minuteDebut=30
secondeDebut=00
heureFin=05
minuteFin=40
secondeFin=00
#____________________________________________________________
espace=" "
forwardSlash="/"
#____________________________________________________________
#-------------------------
while [ $looping  = true ]; do
	#-------------------------
	#Petite attente
	if [ $attendre = true ]; then
		for countDown in 10 9 8 7 6 5 4 3 2 1 0
		do
			sleep 1
			echo "Démarage Serveur dans: "$countDown
		done
	fi
	#-------------------------
	# Lancement du Serveur
	echo "________________________Server Start__________________________"
	$commandeJava$espace$spigotJarPath$espace$commandeJavaEnd
	echo "________________________Server Stop__________________________"
	#-------------------------
	# Save du Serveur
	if [ $saveEnabled = true ]; then
		echo "__________Save Start__________"
		Heure=$(date +%H)
		Minute=$(date +%M)
		Seconde=$(date +%S)
		# -----
		H=${Heure#0}
		M=${Minute#0}
		S=${Seconde#0}
		# -----
		echo "Heure actuelle: "$Heure:$Minute:$Seconde
		echo "Sauvegarde entre: "$heureDebut:$minuteDebut:$secondeDebut" -> "$heureFin:$minuteFin:$secondeFin
		stampNow=$((${Heure#0}*3600+${Minute#0}*60+${Seconde#0}))
		stampDebut=$(($heureDebut*3600+$minuteDebut*60+$secondeDebut))
		stampFin=$(($heureFin*3600+$minuteFin*60+$secondeFin))
		# echo $stampNow #DEBUG
		# echo $stampDebut #DEBUG
		# echo $stampFin #DEBUG
		if [ \( $stampNow -ge $stampDebut \) -a \( $stampNow -le $stampFin \) ]; then
			echo "- Démarage sauvegarde -"
			for countDown in 10 9 8 7 6 5 4 3 2 1 0
			do
				sleep 1
				echo "Démarage Sauvegarde dans: "$countDown
			done
			startTime=$(date +%s)
			#-------------------------
			if [ ! -d $backupDirectory ]; then
				# Control will enter here if $DIRECTORY doesn't exist.
				echo "Création du dossier de sauvegarde: "$backupDirectory$forwardSlash
				mkdir -p $backupDirectory
				sleep 1
			else
				echo "Dossier de sauvegarde OK: "$backupDirectory$forwardSlash
			fi
			#-------------------------
			if [ -d $backupDirectory ]; then
				# Control will enter here if $DIRECTORY exists.
				dateTime=$(date +"%d-%m-%Y_%H-%M-%S")
				"Démarage de la saugegarde vers: "
				echo $backupDirectory$forwardSlash$archiveName"_"$dateTime".tar"
				tar Jcvf $backupDirectory$forwardSlash$archiveName"_"$dateTime".tar" $dossierASauvegarderFullPath
				echo "Fin de la sauvegarde:"
				echo $backupDirectory$forwardSlash$archiveName"_"$dateTime".tar"
			fi
			endTime=$(date +%s)
			#-------------------------
			exectionTime=$(($endTime-$startTime))
			echo "Sauvegarde Auto terminée en $(($exectionTime/60))m$(($exectionTime%60))s."
		else
			echo "- Pas de sauvegarde -"
		fi
		unset -v H
		unset -v M
		unset -v S
		unset -v Heure
		unset -v Minute
		unset -v Seconde
		unset -v stampNow
		unset -v stampDebut
		unset -v stampFin
		unset -v startTime
		unset -v endTime
		unset -v exectionTime
		unset -v dateTime
		echo "__________Save End__________"
	else
		echo "Sauvegarde désactivée"
	fi
	#-------------------------
sleep 1
done
