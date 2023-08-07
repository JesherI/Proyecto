import mysql.connector

def obtener_todos_los_vestidos():
    try:
        mydb = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="spvbl"
        )
        cursor = mydb.cursor()

        consulta = "SELECT * FROM productos"
        cursor.execute(consulta)

        vestidos = cursor.fetchall()

        print("Cantidad de vestidos obtenidos:", len(vestidos)) 


        cursor.close()
        mydb.close()

        return vestidos

    except Exception as e:
        print("Error al obtener los vestidos:", e)
        return None
