# Oracle VM con Vagrant

## Resumen

Básicamente se utiliza una VM con Vagrant en vez de una convencional para minimizar el uso de recursos. En esta VM se instala el Oracle XE 18c y se hace reenvío del puerto 1521 (puerto de Oracle XE) a nuestra PC para que estuviera corriendo como si fuera un servicio más.

## Paso a Paso (Corto)

1. Instalar Vagrant CentOS 7

2. Configurar el reenvio de puertos 1521, para poder conectarse al Orcle-XE de la VM desde el Host (nuestra PC real) usando el mismo puerto y el localhost

3. Configurar el RAM de la VM a 2048mb (2gb como mínimo)

4. Instalar [Pre-install de Oracle](https://docs.oracle.com/en/database/oracle/oracle-database/18/xeinl/procedure-installing-oracle-database-xe.html)

5. Cambiar parámetros del Kernel (dice en [la página de oracle)](https://www.appservgrid.com/documentation111/docs/rdbms18c/ladbi/changing-kernel-parameter-values.html#GUID-FB0CC366-61C9-4AA2-9BE7-233EB6810A31)

6. Instalar el RPM de [Oracle-XE](https://www.oracle.com/database/technologies/xe18c-downloads.html) (pasarlo a la VM con SFTP o vagrant [upload](https://www.vagrantup.com/docs/cli/upload))

    1. Instalar con `yum localinstall`
    2. Configurar con `/etc/init.d/oracle-xe-18c configure`
    3. Iniciar con `/etc/init.d/oracle-xe-18c start`

7. Agregar las variables de ORACLE a /etc/profile o a /etc/profile.d/ (usar `sudo su - oracle` para que se carguen las variables)

   ```bash
   export ORACLE\_SID=XE)
   export ORACLE\_HOME=/opt/oracle/product/18c/dbhomeXE
   export PATH=$PATH:$ORACLE\_HOME/bin
   ```

8. Y usar `lsnrctl status` para comprobar que todo funcione

    1. Para iniciar los Listener usar: `lsnrctl start`
    2. Fijarse en HOST está escuchando (IP) para poder conectarse desde SQL Developer u otro programa (debería escuchar predeterminadamente en localhost)

9. Luego poner en el inicio el servicio como explica la [documentación](https://docs.oracle.com/en/database/oracle/oracle-database/18/xeinl/starting-and-stopping-oracle-database.html):
    1. `/sbin/chkconfig oracle-xe-18c on`

## Instalar Vagrant e instalar una VM de CentOS 7

1. Descargar e instalar Vagrant en sus Sistema operativo aquí
2. Una vez instalado abrir una consola e crear una máquina virtual (VM) (Link)
3. Crear una nueva carpeta donde se guardará la configuración
    1. `mkdir OracleCentOS`
4. Entrar a la carpeta
    1. `cd OracleCentOS`
5. `vagrant init centos/7`
6. `vagrant up` (o directamente del Repositorio clonado usnado el Vagrantfile predeterminado)
7. Una vez instalada e iniciada, hay que conectarse
    1. `vagrant ssh` (dentro de la carpeta)
8. Una vez conectada, hacer lo básico al instalar CentOS
    1. `sudo yum -y update`
    2. `sudo yum install nano`

Adicionalmente se necesita configurar el Vagrantfile para la redirección de puertos (link) agregado estas líneas donde corresponde (debajo del ejemplo que se da en el archivo):

- config.vm.network "forwarded_port", guest: 1521, host: 1521

Y aumentar el RAM de 1024 GB → 2048 GB

![Aumentar RAM](./MoreRam.png)

## Instalar Oracle XE

Instalar los paquetes RPM según se indica en la página de [Oracle XE 18c](https://docs.oracle.com/en/database/oracle/oracle-database/18/xeinl/procedure-installing-oracle-database-xe.html):

1. Descargar con curl e Instalar el preinstall
    1. `curl -o oracle-database-preinstall-18c-1.0-1.el7.x86\_64.rpm https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86\_64/getPackage/oracle- database-preinstall-18c-1.0-1.el7.x86\_64.rpm`
    2. `yum -y localinstall oracle-database-preinstall-18c-1.0-1.el7.x86\_64.rpm`

2. Descargar el RPM de Oracle XE 18c
    1. Y pasarlo a la VM: [vagrant upload](https://www.vagrantup.com/docs/cli/upload)

3. Y en la máquina virtual lo solo queda instalarlo
    1. `sudo yum localinstall oracle-xe.rpm`

4. Cambiar parámetros del Kernel según lo indica la [página de Oracle](https://docs.oracle.com/en/database/oracle/oracle-database/18/xeinl/server-component-kernel-parameter-requirements.html), para cambiarlos [aquí](https://docs.oracle.com/en/database/oracle/oracle-database/18/ladbi/changing-kernel-parameter-values.html#GUID-FB0CC366-61C9-4AA2-9BE7-233EB6810A31) se puede ver como. Aunque se puedan actualizar sin apagar es recomendable un apagado (con vagrant reload)

5. Y configurarlo, (volver a iniciar sesion luego de conectarse)
    1. `sudo /etc/init.d/oracle-xe-18c configure`

6. Si procede sin errores ya la instalación se completo

7. Inciar la base de datos
   1. `sudo /etc/init.d/oracle-xe-18c start`

Setear variables de de Oracle en /etc/profile

Luego como indica el manual de Oracle en el post-install es necesario setear determinadas variables de entorno para poder acceder a los binarios de Oracle XE.

Abrir el editor nano para abrir /etc/profile.d/oracleVar.sh automáticamente al iniciar sesion con cualquier usuario:

- `sudo nano /etc/profile.d/oracleVar.sh`

Y ingresar las variables

```bash
export ORACLE\_SID=XE)
export ORACLE\_HOME=/opt/oracle/product/18c/dbhomeXE
export PATH=$PATH:$ORACLE\_HOME/bin
```

Nuevamente, para este paso, se recomienda reiniciar y comprobar que la configuración de variables de entorno se haya aplicado correctamente (usando `echo $NOMBRE_VAR`)
