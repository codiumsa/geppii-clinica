/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package resources;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

/**
 *
 * @author canetev
 */
public class Resources {

    public static String base = System.getProperty("user.dir") + "\\bodega\\";
    public static ArrayList<String> recursos = new ArrayList<String>();
    public static ArrayList<String> permisos = new ArrayList<String>();
    public static ArrayList<String> tipoPermisos = new ArrayList<String>();
    public static ArrayList<String> actions = new ArrayList<String>();

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws FileNotFoundException, IOException, Exception {
        init();
        cargarRecursos();
        generarPermisos();
        generarRecursosYml("recursos.yml");
        PrintWriter writer = new PrintWriter(base  + "rol.yml", "UTF-8");
        String s = "";
        s = RolCreator.crearRol("Administrador", "administrador", "Administrador del sistema.", "administrador.xls");
        System.out.println(s); writer.write(s);
        s = RolCreator.crearRol("Vendedor", "vendedor", "Vendedor o encargado de sucursal.", "vendedor.xls");
        System.out.println(s); writer.write(s);
        s = RolCreator.crearRol("Contador", "contador", "Contador de la empresa", "contador.xls");
        System.out.println(s); writer.write(s);
        writer.close(); 
    }

    public static void init() {
        tipoPermisos.add("BE");
        tipoPermisos.add("FE");
        actions.add("index");
        actions.add("show");
        actions.add("post");
        actions.add("put");
        actions.add("delete");
    }

    public static void cargarRecursos() throws FileNotFoundException, IOException {
        BufferedReader reader = new BufferedReader(new FileReader(base + "recursos.txt"));
        String line;
        while ((line = reader.readLine()) != null) {
            recursos.add(line);
        }
    }

    public static void generarPermisos() {
        for (String recurso : recursos) {
            for (String tipoPermiso : tipoPermisos) {
                for (String accion : actions) {
                    permisos.add(tipoPermiso + "_" + accion + "_" + recurso);
                }
            }
        }
    }

    public static void generarRecursosYml(String out) throws FileNotFoundException, UnsupportedEncodingException {
        PrintWriter writer = new PrintWriter(base + out, "UTF-8");
        String texto1 = ":\n  codigo: ";
        String texto2 = "\n  descripcion: ";
        String imprimir = "";
        for (String line : permisos) {
            imprimir = line + texto1 + line + texto2 + line + "\n";
            writer.print(imprimir);
        }
        writer.close();
    }

    public static void generarRolAdministrador() throws FileNotFoundException, IOException {
        String texto1 = "Administrador: \n"
                + "  codigo: Adminisrador \n"
                + "  descripcion: Administrador \n"
                + "  recursos: ";
        System.out.print(texto1);
        for (String s : permisos) {
            System.out.print(s + ", ");
        }
    }
}
