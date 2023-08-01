import os
from flask import Blueprint,render_template, url_for, request, redirect
from flask_login import login_required
from werkzeug.utils import secure_filename
from models.db import get_connection
from models.vestidos import agregar_vestido, obtener_todos_los_vestidos,eliminar_vestido_por_id, obtener_vestido_por_id

vestidos_views = Blueprint('vestidos_views', __name__)

@vestidos_views.route('/vestidos/')
@login_required
def ver_vestidos():
    vestidos = obtener_todos_los_vestidos()

    vestidos_modificados = []

    for vestido in vestidos:
        vestido_modificado = list(vestido)
        vestido_modificado[9] = vestido_modificado[9].replace("\\", "/")
        vestidos_modificados.append(vestido_modificado)

    return render_template('users/vestidos/vestidos.html', vestidos=vestidos_modificados)


@vestidos_views.route('/registro_vestido/', methods=['GET', 'POST'])
@login_required
def agregar_vestidos():
    if request.method == 'POST':
        nombre = request.form.get('nombre')
        talla = request.form.get('talla')
        color = request.form.get('color')
        categoria = request.form.get('categoria')
        descripcion = request.form.get('descripcion')
        precio = request.form.get('precio')
        cantidad = 1
        img_vestido = request.files.get('img_vestido')
        if img_vestido and img_vestido.filename != '':
            filename = img_vestido.filename
            img_path = os.path.join('static', 'img', 'vestidos', filename)

            img_vestido.save(img_path)

        estado = "Disponible"

        agregar_vestido(nombre, talla, color, categoria, descripcion, precio, estado, cantidad, img_path)

        return redirect(url_for('vestidos_views.ver_vestidos'))

    return render_template('users/vestidos/resgistro_vestidos.html')

@vestidos_views.route('/vestidos/borrar/<int:id>/', methods=['POST'])
@login_required
def borrar_vestido(id):
    eliminar_vestido_por_id(id)
    return redirect(url_for('vestidos_views.ver_vestidos'))

import os

import os

import os

@vestidos_views.route('/vestidos/actualizar/<int:id>/', methods=['GET', 'POST'])
@login_required
def actualizar_vestido(id):
    vestido = obtener_vestido_por_id(id)

    if not vestido:
        return render_template('error.html', message='El vestido no existe.')

    if request.method == 'POST':
        nombre = request.form.get('nombre')
        talla = request.form.get('talla')
        color = request.form.get('color')
        categoria = request.form.get('categoria')
        descripcion = request.form.get('descripcion')
        precio = request.form.get('precio')
        img_vestido = request.files.get('img_vestido')

        img_path_anterior = vestido[9]

        if img_vestido and img_vestido.filename != '':
            if os.path.exists(img_path_anterior):
                os.remove(img_path_anterior)

            filename = secure_filename(img_vestido.filename)
            img_path_nueva = os.path.join('static', 'img', 'vestidos', filename)
            img_vestido.save(img_path_nueva)
        else:
            img_path_nueva = img_path_anterior

        try:
            with get_connection() as mydb:
                cursor = mydb.cursor()

                sql = "UPDATE productos SET nombre = %s, talla = %s, color = %s, categoria = %s, descripcion = %s, precio = %s, img_vestido = %s WHERE id_producto = %s"
                values = (nombre, talla, color, categoria, descripcion, precio, img_path_nueva, id)

                cursor.execute(sql, values)
                mydb.commit()

        except Exception as e:
            print("Error al actualizar el vestido:", e)

        return redirect(url_for('vestidos_views.ver_vestidos'))

    return render_template('users/vestidos/actualizar_vestido.html', vestido=vestido)