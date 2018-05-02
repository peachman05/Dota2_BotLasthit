# Dota2_BotLasthit
Reinforcement Learning AI for lasthiting

## How to run
### Copy project
1. install **Dota 2 Workshop Tools DLC** in steam
2. open it 
3. click **Create Empty Addon** button 
4. type your addon name
5. goto addon folder in **_Steam\steamapps\common\dota 2 beta\game\dota_addons_**
6. goto **_you_addon_name\scripts\vscripts_**
7. copy all of file and folder in this project and paste in vscripts folder (replace a default **_addon_game_mode.lua_** )
### Run python Server
8. goto **server** folder and run python server by use **_python webservice.py_**
### Run your addon
9. back to your Dota 2 workshop tools , select your addon and click **Launch Custom Game Tools**
10. In **Asset Browser**, Open **V-Console** by cliking a computer icon that is below a help menu.
11. In V-Console, type **dota_launch_custom_game _your_addon_name_ dota**  in command box and run.
### Train model
12. After addon run, you can see a sniper spawn in base. You need to **type anything word** in chat box in game for starting training (I program to reset game when chat box event is comming)
13. See sniper train and NN weight will save in **server/weight_save.h5** every 20 episode.
