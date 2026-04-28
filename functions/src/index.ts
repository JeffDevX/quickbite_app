import * as v2 from "firebase-functions/v2";
import * as admin from "firebase-admin";

admin.initializeApp();

// Microservicio de Órdenes
export const createorder = v2.https.onCall(async (request) => {
  console.log("Procesando nueva orden de:", request.data.client_id);

  try {
    const orderData = {
      client_id: request.data.client_id,
      items: request.data.items,
      total: request.data.total,
      status: "pendiente",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    const docRef = await admin.firestore().collection("orders").add(orderData);

    return {
      success: true,
      orderId: docRef.id,
      message: "Orden procesada por el microservicio",
    };
  } catch (error) {
    console.error("Error en Microservicio:", error);
    throw new v2.https.HttpsError("internal", "Error al procesar la orden");
  }
});

// Microservicio de Identidad y Usuarios
export const registeruser = v2.https.onCall(async (request) => {
  const {email, password, firstName, lastName} = request.data;

  console.log("Intentando registrar nuevo usuario:", email);

  if (!email || !password || !firstName || !lastName) {
    throw new v2.https.HttpsError(
      "invalid-argument",
      "Faltan campos obligatorios para el registro."
    );
  }

  try {
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: `${firstName} ${lastName}`,
    });

    const userData = {
      uid: userRecord.uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: "client",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await admin.firestore().collection("users").doc(userRecord.uid)
      .set(userData);

    return {
      success: true,
      uid: userRecord.uid,
      message: "Usuario creado exitosamente por el microservicio",
    };
  } catch (error) {
    console.error("Error en Microservicio de Registro:", error);
    const err = error as any;
    if (err.code === "auth/email-already-exists") {
      throw new v2.https.HttpsError(
        "already-exists",
        "El correo ya está registrado."
      );
    }
    throw new v2.https.HttpsError("internal", "Error al registrar usuario");
  }
});

// Microservicio de Catálogo Completo
export const getcatalog = v2.https.onCall(async () => {
  try {
    const [prodSnap, catSnap] = await Promise.all([
      admin.firestore().collection("products").get(),
      admin.firestore().collection("categories").get(),
    ]);

    const products = prodSnap.docs.map((doc) => ({id: doc.id, ...doc.data()}));
    const categories = catSnap.docs.map((doc) => ({id: doc.id, ...doc.data()}));

    return {
      success: true,
      products,
      categories,
    };
  } catch (error) {
    throw new v2.https.HttpsError(
      "internal",
      "Error al obtener el catálogo completo"
    );
  }
});

// Microservicio para actualizar estado (Solo Admins)
export const updateorderstatus = v2.https.onCall(async (request) => {
  const {orderId, newStatus} = request.data;
  const uid = request.auth?.uid;

  if (!uid) {
    throw new v2.https.HttpsError("unauthenticated", "Debe estar autenticado.");
  }

  try {
    // 1. VALIDACIÓN DE ROL: Consultamos el perfil en Firestore
    const userDoc = await admin.firestore().collection("users").doc(uid).get();
    const userData = userDoc.data();

    if (!userDoc.exists || userData?.role !== "admin") {
      throw new v2.https.HttpsError(
        "permission-denied",
        "Solo los administradores pueden cambiar estados de pedidos."
      );
    }

    // 2. ACTUALIZACIÓN: Si es admin, procedemos
    await admin.firestore().collection("orders").doc(orderId).update({
      status: newStatus,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      success: true,
      message: `Orden ${orderId} actualizada a ${newStatus}`,
    };
  } catch (error) {
    console.error("Error en updateorderstatus:", error);
    if (error instanceof v2.https.HttpsError) throw error;
    throw new v2.https.HttpsError("internal", "Error al actualizar la orden.");
  }
});

export const getallorders = v2.https.onCall(async (request) => {
  const uid = request.auth?.uid;

  try {
    // Verificación de rol (repetir lógica anterior o crear función helper)
    const userDoc = await admin.firestore().collection("users").doc(uid!).get();
    if (userDoc.data()?.role !== "admin") {
      throw new v2.https.HttpsError("permission-denied", "Acceso denegado.");
    }

    const snapshot = await admin.firestore()
      .collection("orders")
      .orderBy("createdAt", "desc")
      .get();

    const orders = snapshot.docs.map((doc) => ({id: doc.id, ...doc.data()}));

    return {success: true, data: orders};
  } catch (error) {
    throw new v2.https.HttpsError("internal", "Error al obtener pedidos.");
  }
});

