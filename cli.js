
/** main function for eshop
@author Lars Persson for course databas.
-- 2019-03-24
*/
"use strict";
const readline = require('readline');
const eshop = require("./src/eshop_cli.js");//Ändra

(function() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    showMenu();
    rl.setPrompt("Välj från menyn ");
    rl.prompt();

    rl.on("close", process.exit);
    rl.on("line", async (line)=>{
        console.log(line);
        line = line.trim();
        let lineArray = line.split(" ");

        switch (lineArray[0]) {
            case "quit":
            case "exit":
                process.exit();
                break;
            case "menu":
            case "help":
                showMenu();
                break;
            case "about":
                showAbout();
                break;
            case "shelf":
                await eshop.showShelf();
                break;
            case "inventory":
                if (lineArray[1]) {
                    await eshop.searchInventory(lineArray[1]);
                } else {
                    await eshop.showInventory();
                }
                break;
            case "order":
                if (lineArray[1]) {
                    await eshop.searchOrder(lineArray[1]);
                } else {
                    await eshop.showOrder();
                }
                break;
            case "invadd":
                await eshop.invadd(lineArray[1], lineArray[2], lineArray[3]);
                break;
            case "ship":
                await eshop.orderShiped(lineArray[1]);
                break;
            case "picklist":
                await eshop.pickList(lineArray[1]);
                break;
            case "invdel":
                await eshop.invdel(lineArray[1], lineArray[2], lineArray[3]);
                break;
            case "log":
                await eshop.showLog(lineArray[1]);
                break;
            case "logsearch":
                if (lineArray[1]) {
                    await eshop.searchLog(lineArray[1]);
                } else {
                    await eshop.showLogAll();
                }
                break;
            default:
                console.log("Invalid choose or input, please choose from the menu below.\n");
                showMenu();
                break;
        }

        // if (lineArray[1]) {
        //         return await eshop.searchInventory(lineArray[1])
        //     } else {
        //         return await eshop.showInventory();
        //     };

        rl.prompt();
    });
})();

function showMenu() {
    console.info(
        `Välkommen till eshop CDoff.\n\n`+
        `Du kan välja mellan dessa funktioner:\n`+
        `exit, quit: Avslutar programmet.\n`+
        `help, menu: Visar denna meny.\n`+
        `shelf: Visar vilka lagerhyllor som finns på lagret.\n`+
        `inventory: Vilka produkter som finns var i lagret.\n`+
        `invadd <productid> <number> <shelf>: Lägg till, antal produkter på lagerhyllan.\n`+
        `invdel <productid> <number> <shelf>: Plocka bort, antal produkter från
         specifik lagerhylla.\n`+
        `inventory <str>: Sök på lagret efter produktid eller produktnamn eller lagerhylla.\n`+
        `order <search>: Visa samtliga ordrar eller sök på kund- eller orderid.\n`+
        `ship <orderid>: Ändrar status på en order till “Skickad”.\n`+
        `picklist <orderid>: Plocklista för vald order, orderrader och plats på lagert.”.\n`+
        `log <number>: Visar de <number> senaste raderna i loggtabellen.\n`+
        `logsearch <str>: Söksträng <str> som filtrerar vilka rader(max 20)
        som ska visas i loggtabellen.\n`+
        `about: Ansvarig för denna terminalklient.\n\n`
    );
}

function showAbout() {
    console.info(
        `Jag som har skapad denna cli heter Lars Persson och studerar webbprogrammering\n`+
        `på BTH.\n\n`
    );
}
