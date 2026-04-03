const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");
const products = require("./products.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function importData() {
  console.log("=====================================");
  console.log("🚀 INICIANDO IMPORTACIÓN DE PRODUCTOS");
  console.log("=====================================\n");

  console.log(`📦 Total productos encontrados: ${products.length}\n`);

  let counters = {
    Hamburguesas: 0,
    Combos: 0,
    Bebidas: 0,
    Pizzas: 0
  };

  for (const product of products) {

    await db.collection("products").add(product);

    // Contador por categoría
    if (counters[product.category] !== undefined) {
      counters[product.category]++;
    }

    if (product.type === "combo") {
      console.log(`🟣 Combo insertado: ${product.name} | $${product.price}`);
    } else {
      console.log(`🟢 Producto insertado: ${product.name} | ${product.category} | $${product.price}`);
    }
  }

  console.log("\n=====================================");
  console.log("✅ IMPORTACIÓN FINALIZADA");
  console.log("=====================================\n");

  console.log("Resumen por categoría:");
  console.log(`🍔 Hamburguesas: ${counters.Hamburguesas}`);
  console.log(`📦 Combos: ${counters.Combos}`);
  console.log(`🥤 Bebidas: ${counters.Bebidas}`);
  console.log(`🍕 Pizzas: ${counters.Pizzas}`);
}

importData().catch(error => {
  console.error("❌ ERROR DURANTE LA IMPORTACIÓN:");
  console.error(error);
});