# 🎯 Comment les Objectifs Deviennent "Complétés"

## Mécanisme Automatique

Les objectifs passent automatiquement en statut **"completed"** (complété) lorsque la valeur actuelle (`current_value`) atteint ou dépasse la valeur cible (`target_value`).

## 🔄 Mise à Jour Automatique

### 1. **Lors de la Création d'une Activité**
Quand vous créez une nouvelle activité sportive :
- ✅ Tous vos objectifs **actifs** sont automatiquement mis à jour
- ✅ La progression est recalculée en fonction de vos activités
- ✅ Si un objectif atteint sa cible, il passe automatiquement en **"completed"**

### 2. **Lors de la Suppression d'une Activité**
Quand vous supprimez une activité :
- ✅ Les objectifs sont recalculés automatiquement
- ✅ Si la suppression fait descendre la progression, l'objectif reste actif
- ✅ Si l'objectif était complété et redevient incomplet, il reste "completed" (ne revient pas en actif)

### 3. **Mise à Jour Manuelle**
Vous pouvez aussi mettre à jour manuellement en cliquant sur **"🔄 Mettre à jour la progression"** dans la page Objectifs.

## 📊 Calcul de la Progression

La progression est calculée différemment selon le type d'objectif :

### **Durée (duration)**
- Somme de toutes les durées d'activités (en minutes) dans la période de l'objectif

### **Distance (distance)**
- Somme de toutes les distances (en km) dans la période de l'objectif

### **Calories (calories)**
- Somme de toutes les calories brûlées dans la période de l'objectif

### **Nombre d'activités (activities_count)**
- Nombre total d'activités dans la période de l'objectif

## ⏰ Période de l'Objectif

Seules les activités créées **entre la date de début et la date de fin** de l'objectif sont prises en compte pour le calcul de la progression.

## ✅ Passage en "Completed"

Un objectif passe automatiquement en **"completed"** quand :
1. `current_value >= target_value`
2. Cela se fait automatiquement lors de :
   - La création d'une activité
   - La suppression d'une activité
   - La mise à jour manuelle de la progression

## ❌ Passage en "Cancelled"

Un objectif passe automatiquement en **"cancelled"** (annulé) quand :
1. La date de fin est dépassée (`end_date < aujourd'hui`)
2. ET la valeur actuelle est inférieure à la valeur cible (`current_value < target_value`)
3. Cela se vérifie automatiquement à chaque chargement de la liste des objectifs

## 🎮 Exemple Concret

**Objectif** : "Courir 100 km ce mois"
- Type : `distance`
- Valeur cible : `100 km`
- Période : 1er novembre - 30 novembre

**Scénario** :
1. Vous créez une activité de course de 10 km → Progression : 10/100 km
2. Vous créez une activité de course de 25 km → Progression : 35/100 km
3. Vous créez une activité de course de 50 km → Progression : 85/100 km
4. Vous créez une activité de course de 15 km → Progression : 100/100 km ✅
5. **L'objectif passe automatiquement en "completed"** 🎉

## 💡 Astuces

- **Créer des activités régulièrement** : Chaque nouvelle activité met à jour automatiquement vos objectifs
- **Vérifier la période** : Assurez-vous que vos activités sont créées dans la période de l'objectif
- **Mise à jour manuelle** : Utilisez le bouton "Mettre à jour la progression" si vous pensez que la progression n'est pas à jour

## 🔍 Vérification

Pour voir le statut de vos objectifs :
1. Allez sur la page **"🎯 Objectifs"**
2. Les objectifs complétés apparaissent avec un badge **"Terminé"** en vert
3. Les objectifs actifs montrent la progression en temps réel
4. Les objectifs annulés apparaissent avec un badge **"Annulé"** en rouge

---

**✨ Tout est automatique ! Créez simplement vos activités et vos objectifs se mettront à jour tout seuls !**

