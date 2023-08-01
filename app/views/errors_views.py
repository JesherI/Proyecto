from flask import Blueprint, render_template


user_views = Blueprint('errors',__name__)

def pagina_no_encontrada(error):
    return render_template('errors/404.html'), 404

def pagina_protegida(error):
    return render_template('errors/401.html'), 401
