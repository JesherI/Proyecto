from flask import Blueprint, render_template, request, redirect, url_for
from models.vestidos import obtener_todos_los_vestidos
from flask_login import login_required

ventas_views = Blueprint('ventas_views', __name__)


@ventas_views.route('/ventas/')
@login_required
def ver_ventas():
    return render_template('users/ventas/ventas.html')

@ventas_views.route('/generar_venta/')
@login_required
def generar_venta():
    vestidos = obtener_todos_los_vestidos()

    return render_template('users/ventas/generar_venta.html', vestidos=vestidos)

@ventas_views.route('/insertar_cliente', methods=['POST'])
@login_required
def insertar_cliente():
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        telefono = request.form['telefono']

        return redirect(url_for('ventas_views.ver_vestidos'))

    return "Error al insertar el cliente"