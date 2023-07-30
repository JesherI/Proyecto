from .db import get_connection
import os

def agregar_vestido(nombre, talla, color, categoria, descripcion, precio, estado, cantidad, img_vestido):
    mydb = get_connection()
    cursor = mydb.cursor()

    sql = "INSERT INTO productos (nombre, talla, color, categoria, descripcion, precio, estado, cantidad, img_vestido) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
    values = (nombre, talla, color, categoria, descripcion, precio, estado, cantidad, img_vestido)

    cursor.execute(sql, values)
    mydb.commit()

    cursor.close()
    mydb.close()

def obtener_todos_los_vestidos():
    mydb = get_connection()
    cursor = mydb.cursor()
    consulta = "SELECT * FROM productos WHERE estado = 'Disponible'"
    cursor.execute(consulta)

    vestidos = cursor.fetchall()

    cursor.close()
    mydb.close()
    return vestidos

def eliminar_vestido_por_id(producto_id):
    mydb = get_connection()
    cursor = mydb.cursor()

    consulta = "SELECT img_vestido FROM productos WHERE id_producto = %s"
    cursor.execute(consulta, (producto_id,))
    resultado = cursor.fetchone()
    if resultado:
        img_path = resultado[0]

        consulta = "DELETE FROM productos WHERE id_producto = %s"
        cursor.execute(consulta, (producto_id,))
        mydb.commit()

        if os.path.exists(img_path):
            os.remove(img_path)

    cursor.close()
    mydb.close()


def obtener_vestido_por_id(id):
    mydb = get_connection()
    cursor = mydb.cursor()

    consulta = "SELECT * FROM productos WHERE id_producto = %s"
    cursor.execute(consulta, (id,))

    vestido = cursor.fetchone()

    cursor.close()
    mydb.close()

    return vestido


def actualizar_vestido(id_producto, nombre, talla, color, categoria, descripcion, precio, estado, cantidad, img_vestido):
    try:
        with get_connection() as mydb:
            cursor = mydb.cursor()

            consulta = "SELECT img_vestido FROM productos WHERE id_producto = %s"
            cursor.execute(consulta, (id_producto,))
            resultado = cursor.fetchone()
            if resultado:
                img_path = resultado[0]

                sql = "UPDATE productos SET nombre = %s, talla = %s, color = %s, categoria = %s, descripcion = %s, precio = %s, estado = %s, cantidad = %s, img_vestido = %s WHERE id_producto = %s"
                values = (nombre, talla, color, categoria, descripcion, precio, estado, cantidad, img_vestido, id_producto)

                cursor.execute(sql, values)
                mydb.commit()

                if os.path.exists(img_path) and img_path != img_vestido:
                    os.remove(img_path)

    except Exception as e:
        print("Error al actualizar el vestido:", e)

def actualizar_vestido_en_db(id, nombre, talla, color, categoria, descripcion, precio, estado, cantidad, img_path):
    try:
        with get_connection() as mydb:
            cursor = mydb.cursor()

            sql = "UPDATE productos SET nombre = %s, talla = %s, color = %s, categoria = %s, descripcion = %s, precio = %s, estado = %s, cantidad = %s, img_vestido = %s WHERE id_producto = %s"
            values = (nombre, talla, color, categoria, descripcion, precio, estado, cantidad, img_path, id)

            cursor.execute(sql, values)
            mydb.commit()

    except Exception as e:
        print("Error al actualizar el vestido:", e)

def obtener_vestido_por_id(id):
    try:
        with get_connection() as mydb:
            cursor = mydb.cursor()

            consulta = "SELECT * FROM productos WHERE id_producto = %s"
            cursor.execute(consulta, (id,))

            vestido = cursor.fetchone()

            return vestido

    except Exception as e:
        print("Error al obtener el vestido:", e)
        return None