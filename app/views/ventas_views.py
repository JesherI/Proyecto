from flask import Blueprint, render_template
from models.vestidos import obtener_todos_los_vestidos
from flask_login import login_required

ventas_views = Blueprint('ventas_views', __name__)

@ventas_views.route('/ventas/')
@login_required
def ver_vestidos():
    vestidos = obtener_todos_los_vestidos()

    return render_template('users/ventas/ventas.html', vestidos=vestidos)
