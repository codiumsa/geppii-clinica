/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package resources;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import utils.XLSReaderUtil;

/**
 * Created:16/05/2014
 *
 * @author canetev
 */
public class RolCreator {

    public static String base =  System.getProperty("user.dir") + "\\bodega\\";
    public static List<String[]> excel = new ArrayList<String[]>();

    public static String crearRol(String rol, String codigo, String descripcion, String file) throws IOException, Exception {
        init(file);
        return generarRol(rol, codigo, descripcion);
    }

    public static void init(String file) throws IOException, Exception {
        Path path = Paths.get(base + file);
        excel = XLSReaderUtil.getListaDeArraysDesdeXLS(Files.readAllBytes(path));
    }
    
    public static String generarRol(String rol, String codigo, String descripcion){
        String encabezado = rol + ":\n  " + "codigo: " + codigo + "\n  descripcion: " + descripcion + "\n  recursos: ";
        String recurso = "";
        String [] permiso = excel.get(0);
        for(String[] fila : excel){
            recurso = fila[0];
            for (int col = 1; col < 11; col++){
                if (fila[col].equalsIgnoreCase("S")){
                    encabezado += permiso[col] + "_" + recurso + ", ";
                    //System.out.print(permiso[col] + "_" + recurso + ", ");
                }
            }
        }
        encabezado += "\n";
        return encabezado;
    }
}