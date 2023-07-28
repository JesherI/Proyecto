import os
from flask import Blueprint,render_template, url_for, request, redirect
from models.db import get_connection
from flask_login import login_required
from models.vestidos import agregar_vestido, obtener_todos_los_vestidos
from flask_wtf.csrf import CSRFProtect

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