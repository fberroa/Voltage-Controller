# Voltage-Controller
<h3>Control de tensión de motor eléctrico utilizando el ADC de un PIC12F683.</h3>
<i>Lenguaje de programación: Assembly</i>


<h3>Detección de Sobretensión:</h3>
<p>Como medida de seguridad y para prevenir que el motor se deteriore, al momento que se detecte una sobretensión se detendrá el motor cortando completamente la alimentación. El sistema compara el voltaje medido con un voltaje umbral predefinido, se realiza una resta aritmética entre el voltaje leído por el ADC y el voltaje que definimos como umbral.</p>
<h3>Comparación = Voltaje leído - Umbral</h3>

<p>- Si el resultado positivo, se detecta una sobrecarga, se activan acciones de protección.</p>
<p>- Si el resultado es valor negativo, no se detecta sobrecarga y se vuelve a leer el ADC.</p>

Ejemplo:
Tenemos un umbral predefinido de 3V, es decir, la tensión máxima tolerable. Si la lectura del ACD arroja un valor X.
<p>Comparación = X-3</p>
<p>Si la comparación arroja un valor positivo, la bandera C marcará se activará. Por lo tanto, se hará un salto a rutina de apagado del motor.</p>
