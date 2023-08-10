from flask import Blueprint, render_template, request, redirect, url_for
from models.db import get_connection
from flask_login import login_required,current_user
from datetime import datetime
import mysql.connector.errors
from models.vestidos import obtener_vestido_por_id


ventas_views = Blueprint('ventas_views', __name__)

@ventas_views.route('/ventas/')
@login_required
def ver_ventas():
    return render_template('users/ventas/ventas.html')

@ventas_views.route('/generar_venta/', methods=['GET', 'POST'])
@login_required
def generar_venta():
    vestido = obtener_vestido_por_id(id)
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        telefono = request.form['telefono']
        abono = float(request.form['abono'])
        productos_comprados = request.form.getlist('productos')

        connection = get_connection()
        cursor = connection.cursor()

        try:
            cursor.execute("SELECT id_cliente FROM cliente WHERE nombre = %s AND apellido = %s AND telefono = %s",
                           (nombre, apellido, telefono))
            existing_client = cursor.fetchone()

            if existing_client:
                cliente_id = existing_client[0]
            else:
                cursor.execute("INSERT INTO cliente (nombre, apellido, telefono) VALUES (%s, %s, %s)",
                               (nombre, apellido, telefono))
                cliente_id = cursor.lastrowid

            fecha = datetime.now().date()
            usuario_id = current_user.id
            cursor.execute("INSERT INTO compras (id_cliente, fecha, total, id_usuario, abono) VALUES (%s, %s, 0, %s, %s)",
                           (cliente_id, fecha, usuario_id, abono))
            compra_id = cursor.lastrowid

            total = 0
            for producto_id in productos_comprados:
                cursor.execute("SELECT precio FROM productos WHERE id_producto = %s", (producto_id,))
                precio = cursor.fetchone()[0]
                total += precio
                cursor.execute("INSERT INTO detalles_venta (id_venta, id_producto) VALUES (%s, %s)",
                               (compra_id, producto_id))

                nuevo_estado = 'Vendido' if abono >= precio else 'Apartado'
                cursor.execute("UPDATE productos SET estado = %s WHERE id_producto = %s",
                               (nuevo_estado, producto_id))

            cursor.execute("UPDATE compras SET total = %s WHERE id_compra = %s", (total, compra_id))
            connection.commit()
        except mysql.connector.errors.Error as err:
            connection.rollback()
            print("Error:", err)
        finally:
            cursor.close()
            connection.close()

        productos = obtener_productos()
        clientes = obtener_clientes()
        return render_template('users/ventas/ventas.html', productos=productos, clientes=clientes, vestido=vestido)

    else:
        connection = get_connection()
        cursor = connection.cursor()

        try:
            productos = obtener_productos()
            cursor.execute("SELECT id_cliente, nombre, apellido FROM cliente")
            clientes = cursor.fetchall()
        except mysql.connector.errors.Error as err:
            print("Error:", err)
            productos = []
            clientes = []
        finally:
            cursor.close()
            connection.close()

        return render_template('users/ventas/generar_venta.html', productos=productos, clientes=clientes, vestido=vestido)

    
def obtener_productos():
    mydb = get_connection()
    cursor = mydb.cursor()
    consulta = "SELECT * FROM productos WHERE estado = 'Disponible'"
    cursor.execute(consulta)

    vestidos = cursor.fetchall()

    for producto in vestidos:
        print("ID:", producto[0])
        print("Nombre:", producto[1])
        print("Ruta de Imagen:", producto[9])
        print("---")

    cursor.close()
    mydb.close()
    return vestidos

def obtener_clientes():
    connection = get_connection()
    cursor = connection.cursor()
    consulta = "SELECT id_cliente, nombre, apellido FROM cliente"
    cursor.execute(consulta)

    clientes = cursor.fetchall()

    cursor.close()
    connection.close()
    return clientes