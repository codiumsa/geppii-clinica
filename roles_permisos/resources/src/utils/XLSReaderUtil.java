/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.util.ArrayList;
import java.util.List;
import jxl.Cell;
import jxl.Workbook;

/**
 *
 * @author vanecanete
 */
public class XLSReaderUtil {
    
    public XLSReaderUtil() {
    }

    public static List<String[]> getListaDeArraysDesdeXLS(byte[] data) throws Exception {

        Workbook workbook = null;
        try {
            workbook = Workbook.getWorkbook(new ByteArrayInputStream(data));
        } catch (IOException ex) {
            throw new Exception("Error al leer el fichero", ex);
        } catch (Exception ex) {
            throw new Exception("Fichero .xls no valido. Asegurese que su formato sea Excel 97", ex);
        }

        int nrows = workbook.getSheet(0).getRows() - 1;
        List<String[]> R = new ArrayList<String[]>(nrows);
        Cell[] cells;
        for (int i = 0; i <= nrows; i++) {

//          cells = workbook.getSheet(0).getRow(i + 1);
            cells = workbook.getSheet(0).getRow(i);
            R.add(new String[cells.length]);
            for (int j = 0; j < cells.length; j++) {
                R.get(i)[j] = cells[j].getContents();
            }
        }
        return R;
    }
    public static List<String[]> getListaDeArraysDesdeXLSMinColumn(byte[] data, int minColumn) throws Exception {

        Workbook workbook = null;
        try {
            workbook = Workbook.getWorkbook(new ByteArrayInputStream(data));
        } catch (IOException ex) {
            throw new Exception("Error al leer el fichero", ex);
        } catch (Exception ex) {
            throw new Exception("Fichero .xls no valido. Asegurese que su formato sea Excel 97", ex);
        }

        int nrows = workbook.getSheet(0).getRows() - 1;
        List<String[]> R = new ArrayList<String[]>(nrows);
        Cell[] cells;
        for (int i = 0; i <= nrows; i++) {

//          cells = workbook.getSheet(0).getRow(i + 1);
            cells = workbook.getSheet(0).getRow(i);
            R.add(new String[minColumn]);
            for (int j = 0; j < minColumn; j++) {
                try{
                    R.get(i)[j] = cells[j].getContents();
                }catch(Exception e){
                    R.get(i)[j]="";
                }
            }
        }
        return R;
    }
    public static List<String[]> getListaDesdeXLS(byte[] data) throws Exception {

        Workbook workbook = null;
        try {
            workbook = Workbook.getWorkbook(new ByteArrayInputStream(data));
        } catch (IOException ex) {
            throw new Exception("Error al leer el fichero", ex);
        } catch (Exception ex) {
            throw new Exception("Fichero .xls no valido. Asegurese que su formato sea Excel 97", ex);
        }

        int nrows = workbook.getSheet(0).getRows() - 1;
        List<String[]> R = new ArrayList<String[]>(nrows);
        Cell[] cells;
        for (int i = 0; i < nrows; i++) {

//          cells = workbook.getSheet(0).getRow(i + 1);
            cells = workbook.getSheet(0).getRow(i);
            R.add(new String[cells.length]);
            for (int j = 0; j < cells.length; j++) {
                R.get(i)[j] = cells[j].getContents();
            }
        }
        return R;
    }


    public static List<String[]> getListaDeArraysDesdeCSV(byte[] dataz) throws Exception {
        ByteArrayInputStream is = new ByteArrayInputStream(dataz);
        LineNumberReader reader = new LineNumberReader(new InputStreamReader(is));

        List<String[]> R = new ArrayList<String[]>();
        String line;
        try {
//            reader.readLine();
            line = reader.readLine();
            do {
                R.add(line.split(";"));
                line = reader.readLine();
            } while (line != null);
        } catch (IOException ex) {
            throw new Exception("Error al leer el fichero", ex);
        }
        return R;
    }
}
