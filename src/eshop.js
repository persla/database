/**
 * A module exporting functions to access the eshop database.
 */
"use strict";

module.exports = {
    showCategory: showCategory,
    showProduct: showProduct,
    createProduct: createProduct,
    showAllId: showAllId,
    editProduct: editProduct,
    deleteProduct: deleteProduct,
    showCustomer: showCustomer,
    createOrder: createOrder,
    showAllOrders: showAllOrders,
    showAllIdOrder: showAllIdOrder,
    showProductForOrder: showProductForOrder,
    insertOrder: insertOrder,
    insertUpdateTimeOrderd: insertUpdateTimeOrderd,
    showAllCategory: showAllCategory,
    showLoggAll: showLoggAll,
    loggSearch: loggSearch,
    showProductAll: showProductAll
};

const mysql  = require("promise-mysql");
const config = require("../config/db/eshop.json"); //ändra och döp om
let db;



/**
 * Main function.
 * @async
 * @returns void
 */
(async function() {
    db = await mysql.createConnection(config);

    process.on("exit", () => {
        db.end();
    });
})();


async function showProductAll() {
    let sql = `CALL show_all();`;
    let res;

    res = await db.query(sql);
    // console.log(res);
    // console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}
async function showCategory() {
    let sql = `CALL show_category();`;
    let res;

    res = await db.query(sql);
    // console.log(res);
    // console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}

async function showProduct() {
    let sql = `CALL show_product();`;
    let res;

    res = await db.query(sql);
    // console.log(res);
    // console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}

async function showLoggAll() {
    let sql = `CALL show_log_all();`;
    let res;

    res = await db.query(sql);
    console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}

async function createProduct(body) {
    if (typeof body.category === 'string' || body.category instanceof String) {
        console.log("Sträng");
        let sql = `CALL product_create(?, ?, ?, ?, ?, ?, ?, ?);`;

        body.category = body.category.split();
        await db.query(sql, [body.kod, body.pris, body.titel, body.bildlank, body.beskrivning,
            body.category[0], body.category[1], body.category[2]]);
    } else {
        let sql = `CALL product_create(?, ?, ?, ?, ?, ?, ?, ?);`;

        await db.query(sql, [body.kod, body.pris, body.titel, body.bildlank, body.beskrivning,
            body.category[0], body.category[1], body.category[2]]);
        console.log("Array");
    }
    // console.log(typeof body.category);
    // console.log(body.category);
    // console.log(body.category[0]);
    // console.log(body.category[1]);
    // console.log(body.category[2]);
    var count = Object.keys(body.category).length;

    console.log(count);

    // var count = Object.keys(body.category).length;
    // console.log(count);
    // var count = Object.keys(body.category).length;
    // console.log(count);
    // console.log(body.category);
    // console.log(typeof body.category);
    // console.info(`SQL: ${sql} got ${res.length} rows.`);
}

async function showAllId(kod) {
    let sql = `CALL show_all_id(?);`;
    let res;

    res = await db.query(sql, [kod]);
    // console.log(res);
    // console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function loggSearch(body) {
    let sql = `CALL show_log_search(?);`;
    let res1;

    res1 = await db.query(sql, [body.search]);
    console.log(res1);
    console.info(`SQL: ${sql} got ${res1.length} rows.`);
    return res1[0];
}

async function showAllCategory(kategori) {
    let sql = `CALL show_product_category(?);`;
    let res;

    res = await db.query(sql, [kategori]);
    // console.log(res);
    // console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function editProduct(body) {
    if (typeof body.category === "undefined") {
        console.log("Oidentifrierad");
        let sql = `CALL edit_product(?, ?, ?, ?, ?, ?, ?, ?);`;

        body.category = [];
        await db.query(sql, [body.kod, body.pris, body.titel, body.bildlank, body.beskrivning,
            body.category[0], body.category[1], body.category[2]]);
    }
    console.log(body.category);
    console.log(typeof body.category);
    var count = Object.keys(body.category).length;

    console.log(count);
    if (typeof body.category === 'string' || body.category instanceof String) {
        console.log("Sträng");
        body.category = body.category.split();
        let sql = `CALL edit_product(?, ?, ?, ?, ?, ?, ?, ?);`;

        await db.query(sql, [body.kod, body.pris, body.titel, body.bildlank, body.beskrivning,
            body.category[0], body.category[1], body.category[2]]);
    } else {
        let sql = `CALL edit_product(?, ?, ?, ?, ?, ?, ?, ?);`;

        await db.query(sql, [body.kod, body.pris, body.titel, body.bildlank, body.beskrivning,
            body.category[0], body.category[1], body.category[2]]);
    }
    //console.log(res);
    // console.info(`SQL: ${sql} got ${res.length} rows.`);
}

async function deleteProduct(kod) {
    let sql = `CALL delete_product(?);`;
    let res;

    res = await db.query(sql, [kod]);
    console.log(kod);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
}

async function showCustomer() {
    let sql = `CALL show_customer();`;
    let res;

    res = await db.query(sql);
    // console.log(res);
    // console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}

async function createOrder(kundnr) {
    let sql = `CALL order_create(?);`;
    let res;

    // console.log(body);
    res = await db.query(sql, [kundnr]);
    // return res[0];
    console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
}


async function showAllOrders() {
    let sql = `CALL show_all_orders();`;
    let res;

    res = await db.query(sql);
    // console.log(res);
    // console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}

async function showAllIdOrder(id) {
    let sql = `CALL show_all_id_order(?);`;
    let res;

    res = await db.query(sql, [id]);
    // console.log(res);
    // console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function showProductForOrder() {
    let sql = `CALL show_product_for_order;`;
    let res;

    res = await db.query(sql);
    // console.log(res);
    // console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function insertOrder(body) {
    let sql = `CALL insert_order(?, ?, ?);`;
    let res;

    res = await db.query(sql, [body.order_id, body.prod_kod, body.antal]);
    //console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
}

async function insertUpdateTimeOrderd(id) {
    let sql = `CALL insert_update_time_orderd(?);`;
    let res;

    res = await db.query(sql, [id]);
    //console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
}
