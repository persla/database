/**
 * A module exporting functions to access databse eshop .
 */
"use strict";


const mysql  = require("promise-mysql");
const config = require("../config/db/eshop.json");//ändra och byt namn

require('console.table');
//var table = require('cli-table3');

const banks = {
    //Shows
    showShelf: async function () {
        const db = await mysql.createConnection(config);
        let sql =` CALL show_shelf();`;
        let res = await db.query(sql);

        console.table(res[0]);
        db.end();
    },

    //Shows information about all inventorys
    showInventory: async function () {
        const db = await mysql.createConnection(config);
        let sql =` CALL show_inventory();`;
        let res = await db.query(sql);

        console.table(res[0]);
        db.end();
    },
    //insert into lager
    invadd: async function (productid, number, shelf) {
        // console.log(productid, shelf, number);
        const db = await mysql.createConnection(config);
        let sql =` CALL invadd('${productid}', ${number}, '${shelf}');`;

        await db.query(sql);
        // console.table(res[0]);
        db.end();
    },
    invdel: async function (productid, number, shelf) {
        // console.log(productid, shelf, number);
        const db = await mysql.createConnection(config);
        let sql =` CALL reduce_product('${productid}', ${number}, '${shelf}');`;

        await db.query(sql);
        // console.table(res[0]);
        db.end();
    },
    searchInventory: async function (search) {
        // console.log(productid, shelf, number);
        const db = await mysql.createConnection(config);
        let sql =` CALL search_inventory('%${search}%');`;
        let res = await db.query(sql);

        console.table(res[0]);
        db.end();
    },
    showLog: async function (number) {
        // console.log(productid, shelf, number);
        const db = await mysql.createConnection(config);
        let sql =` CALL show_log('${number}');`;
        let res = await db.query(sql);

        console.table(res[0]);
        db.end();
    },
    showOrder: async function () {
        const db = await mysql.createConnection(config);
        let sql =` CALL show_all_orders();`;
        let res = await db.query(sql);

        console.table(res[0]);
        db.end();
    },
    searchOrder: async function (search) {
        // console.log(productid, shelf, number);
        const db = await mysql.createConnection(config);
        let sql =` CALL search_order('%${search}%');`;
        let res = await db.query(sql);

        console.table(res[0]);
        db.end();
    },
    orderShiped: async function (id) {
        // console.log(productid, shelf, number);
        const db = await mysql.createConnection(config);
        let sql =` CALL insert_update_time_shiped('${id}');`;

        await db.query(sql);
        // console.table(res[0]);
        db.end();
    },
    pickList: async function (id) {
        // console.log(productid, shelf, number);
        const db = await mysql.createConnection(config);
        let sql =` CALL pick_list('${id}');`;
        let res = await db.query(sql);

        console.table(res[0]);
        // console.table(res[0]);
        db.end();
    },
    showLogAll: async function () {
        const db = await mysql.createConnection(config);
        // let sql =` CALL show_all_orders();`;
        let sql = `CALL show_log_all();`;
        let res = await db.query(sql);

        console.table(res[0]);
        db.end();
    },
    searchLog: async function (search) {
        // console.log(productid, shelf, number);
        const db = await mysql.createConnection(config);
        let sql =`CALL show_log_search('%${search}%');`;
        // let sql =` CALL search_order('%${search}%');`;
        let res = await db.query(sql);

        console.table(res[0]);
        db.end();
    },
};

module.exports = banks;
