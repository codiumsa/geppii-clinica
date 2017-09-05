/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 *
 * @author vanecanete
 */
public class PropertiesFileReader {
    public Properties getProperties() 
    {
        try
        {
            //se crea una instancia a la clase Properties
            Properties propiedades = new Properties();
            //se leen el archivo .properties
            InputStream is = this.getClass().getClassLoader().getResourceAsStream("META-INF/testerconf.properties");
            propiedades.load(is);
            //si el archivo de propiedades NO esta vacio retornan las propiedes leidas
            if (!propiedades.isEmpty()) 
            {                
                return propiedades;
            } else {//sino  retornara NULL
                return null;
            }
        } catch (IOException ex) {
            ex.printStackTrace();
            return null;
        }
   }
}
