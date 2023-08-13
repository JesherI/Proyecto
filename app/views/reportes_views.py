from flask import Blueprint, render_template
from flask_login import login_required

reportes_views = Blueprint('reportes_views', __name__)

@reportes_views.route('/reportes/')
@login_required
def reportes():
       return render_template('users/reporte/reporte.html')
