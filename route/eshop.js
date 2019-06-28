/**
 * Route for bank.
 */
"use strict";

const express = require("express");
const router  = express.Router();
const bodyParser = require("body-parser");
const urlencodedParser = bodyParser.urlencoded({ extended: false });
const eshop   = require("../src/eshop.js"); //ändra och döp om

router.get("/index", (req, res) => {
    let data = {
        title: "Welcome | eshop"
    };

    res.render("eshop/index", data); //ändra
});

router.get("/log", urlencodedParser, async (req, res) => {
    let data = {
        title: "Logg | eshop"
    };

    data.res = await eshop.showLoggAll(); //byt namn eshop.
    // data.res1 = await eshop.loggSearch(req.body);
    res.render("eshop/logg", data);
});

router.post("/log", urlencodedParser, async (req, res) => {
    console.log(JSON.stringify(req.body, null, 4));
    let data = {
        title: "Logg | eshop"
    };

    data.res = await eshop.loggSearch(req.body);
    // await eshop.loggSearch(req.body);
    res.render("eshop/logg", data);
});

router.get("/logg-search/", urlencodedParser, async (req, res) => {
    let data = {
        title: "Ändra produkt | eshop",
        id: req.params.id
    };

    data.res = await eshop.loggSearch(req.params.id);
    console.log(req.params.id);
    console.log(JSON.stringify(req.body, null, 4));
    res.render("eshop/logg-search", data);
});

router.get("/about", (req, res) => {
    let data = {
        title: "About | eshop"
    };

    res.render("eshop/about", data);
});

router.get("/category", async (req, res) => {
    let data = {
        title: "Kategorier | eshop"
    };

    data.res = await eshop.showCategory();
    res.render("eshop/category", data);
});

router.get("/product", async (req, res) => {
    let data = {
        title: "Produkter | eshop"
    };

    data.res = await eshop.showProduct();
    res.render("eshop/product", data);
});

router.get("/product-create", async (req, res) => {
    let data = {
        title: "Ny produkt | eshop"
    };

    data.res = await eshop.showCategory();
    data.res1 = await eshop.showProductAll();

    res.render("eshop/product-create", data);
});

router.post("/product-create", urlencodedParser, async (req, res) => {
    console.log(JSON.stringify(req.body, null, 4));
    // console.log(req.body.category[0]);
    // console.log(req.body.category[1]);
    //
    // console.log(typeof req.body.category);
    // console.log(req.body[0].category);
    // var count = Object.keys(req.body.category).length;
    // console.log(count);
    // console.log( _.keys(req.body.Data).length );
    // var count = Object.keys(req.body).length;
    // console.log(count);
    await eshop.createProduct(req.body);
    // console.log(JSON.stringify(req.body.length, null, 4));
    res.redirect("/eshop/product");
});

router.get("/edit/:id", async (req, res) => {
    let data = {
        title: "Ändra produkt | eshop",
        id: req.params.id
    };

    data.res = await eshop.showAllId(req.params.id);
    data.res1 = await eshop.showCategory();
    res.render("eshop/update", data);
});

router.post("/edit", urlencodedParser, async (req, res) => {
    //console.log(JSON.stringify(req.body, null, 4));
    await eshop.editProduct(req.body);
    res.redirect(`/eshop/product`);
});

router.get("/delete/:id", async (req, res) => {
    // let id = req.params.id;
    let data = {
        title: `Radera produkt | eshop`,
        id: req.params.id
    };

    data.res = await eshop.showAllId(req.params.id);

    res.render("eshop/product-delete", data);
});

router.post("/delete", urlencodedParser, async (req, res) => {
    //console.log(JSON.stringify(req.body, null, 4));
    await eshop.deleteProduct(req.body.kod);
    res.redirect(`/eshop/product`);
});

router.get("/show/:id", async (req, res) => {
    // let id = req.params.id;
    let data = {
        title: `Visa produkt | eshop`,
        id: req.params.id
    };

    data.res = await eshop.showAllId(req.params.id);

    res.render("eshop/product-show", data);
});

router.get("/show-category/:id", async (req, res) => {
    // let id = req.params.id;
    let data = {
        title: `Visa Kategori | eshop`,
        id: req.params.id
    };

    data.res = await eshop.showAllCategory(req.params.id);
    console.log(data);

    res.render("eshop/category-show", data);
});

router.get("/customer", async (req, res) => {
    let data = {
        title: "Kunder | eshop"
    };

    data.res = await eshop.showCustomer();
    res.render("eshop/customer", data);
});

router.get("/customer-elect", async (req, res) => {
    let data = {
        title: "Kunder | eshop"
    };

    data.res = await eshop.showCustomer();
    res.render("eshop/customer-elect", data);
});

router.post("/customer-elect", urlencodedParser, async (req, res) => {
    console.log(JSON.stringify(req.body, null, 4));
    // let data = {
    //     title: "Order | eshop",
    //     id: req.params.id
    // };
    await eshop.createOrder(req.body.kundnr);
    // console.log(req.body.kundnr);
    // data.res = await eshop.showCustomer();
    res.redirect("/eshop/product-elect");
});

router.get("/product-elect", urlencodedParser, async  (req, res) => {
    let data = {
        title: "Visa Order | eshop",
        id: req.params.id,
        kundnr: req.body.kundnr
    };

    console.log(req.params.id);
    data.res = await eshop.showAllOrders();
    res.render("eshop/product-elect", data);
});

router.get("/show-order/:id", async (req, res) => {
    // let id = req.params.id;
    let data = {
        title: `Visa order | eshop`,
        id: req.params.id
    };

    data.res = await eshop.showAllIdOrder(req.params.id);
    res.render("eshop/order-show", data);
});

router.get("/ordering-order/:id", async (req, res) => {
    // let id = req.params.id;
    let data = {
        title: `Visa order | eshop`,
        id: req.params.id
    };

    data.res = await eshop.showProductForOrder();

    res.render("eshop/ordering-order", data);
});

router.post("/ordering-order/:id", urlencodedParser, async (req, res) => {
    // let data = {
    //     title: "Order | eshop",
    //     id: req.params.id
    // };
    await eshop.insertOrder(req.body);
    console.log(req.params.id);
    res.redirect("/eshop/show-order/"+ req.params.id +"");
});

router.post("/show-order/:id", urlencodedParser, async (req, res) => {
    // let id = req.params.id;
    // let data = {
    //     title: `Visa order | eshop`,
    //     id: req.params.id
    // };
    await eshop.insertUpdateTimeOrderd(req.params.id);
    res.redirect("/eshop/product-elect");
});

module.exports = router;
