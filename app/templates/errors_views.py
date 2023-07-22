from flask import Blueprint, render_template, url_for, redirect, current_app


user_views = Blueprint('errors',__name__)

def pagina_no_encontrada(error):
    return render_template('errors/404.html'), 404
