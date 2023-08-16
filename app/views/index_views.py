from flask import Blueprint, render_template
from models.vestidos import obtener_todos_los_vestidos

index_views = Blueprint('index',__name__)

@index_views.route('/')
def index():
    return render_template('index/index.html')

@index_views.route('/index-vestidos/')
def index_vestidos():

    all_vestidos = obtener_todos_los_vestidos()
    total_items = len(all_vestidos)
    
    
    vestidos = all_vestidos

    vestidos_modificados = []
    
    for vestido in vestidos:
        vestido_modificado = list(vestido)
        vestido_modificado[9] = vestido_modificado[9].replace("\\", "/")
        vestidos_modificados.append(vestido_modificado)

    return render_template('users/vestidos-index.html', vestidos=vestidos_modificados, total_pages=total_items)
