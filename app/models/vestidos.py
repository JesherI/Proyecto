from .db import get_connection

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
    consulta = "SELECT * FROM productos"
    cursor.execute(consulta)

    vestidos = cursor.fetchall()

    cursor.close()
    mydb.close()
    return vestidos