package com.spring.app.attendance;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.Duration;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;


@Component
public class AttendanceExcelUtil {

    public ByteArrayInputStream generateAttendanceExcel(List<Map<String, Object>> data, String date) {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("출석현황");

            CellStyle headerStyle = createHeaderStyle(workbook);
            CellStyle dataStyle = createDataStyle(workbook);
            CellStyle titleStyle = createTitleStyle(workbook);

            Row titleRow = sheet.createRow(0);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("출석 현황 - " + date);
            titleCell.setCellStyle(titleStyle);
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 5));

            Row headerRow = sheet.createRow(2);
            String[] headers = {"트레이너명", "출근시간", "퇴근시간", "근무시간", "상태", "날짜"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            for (int i = 0; i < data.size(); i++) {
                Row row = sheet.createRow(i + 3);
                Map<String, Object> a = data.get(i);

                writeCell(row, 0, getString(a, "name"), dataStyle);
                writeCell(row, 1, formatTime(a.get("checkinTime")), dataStyle);
                writeCell(row, 2, formatTime(a.get("checkoutTime")), dataStyle);
                writeCell(row, 3, calcWorkHours(a.get("checkinTime"), a.get("checkoutTime")), dataStyle);

                Cell statusCell = row.createCell(4);
                String status = getStatus(a.get("checkinTime"));
                statusCell.setCellValue(status);
                CellStyle statusStyle = workbook.createCellStyle();
                statusStyle.cloneStyleFrom(dataStyle);
                if ("지각".equals(status)) {
                    statusStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
                } else if ("결근".equals(status)) {
                    statusStyle.setFillForegroundColor(IndexedColors.RED.getIndex());
                } else {
                    statusStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
                }
                statusStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                statusCell.setCellStyle(statusStyle);

                writeCell(row, 5, date, dataStyle);
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
                if (sheet.getColumnWidth(i) < 3000) sheet.setColumnWidth(i, 3000);
            }

            ByteArrayOutputStream out = new ByteArrayOutputStream();
            workbook.write(out);
            return new ByteArrayInputStream(out.toByteArray());
        } catch (IOException e) {
            throw new RuntimeException("Excel 파일 생성 오류", e);
        }
    }

    private String getString(Map<String, Object> map, String key) {
        Object v = map.get(key);
        return v != null ? v.toString() : "-";
    }

    private String formatTime(Object t) {
        if (t == null) return "-";
        if (t instanceof LocalTime) return t.toString();
        if (t instanceof java.sql.Time) return ((java.sql.Time) t).toLocalTime().toString();
        if (t instanceof String) return t.toString();
        return "-";
    }

    private String calcWorkHours(Object in, Object out) {
        LocalTime t1 = toTime(in), t2 = toTime(out);
        if (t1 == null || t2 == null) return "-";
        Duration d = Duration.between(t1, t2);
        return d.toHours() + "시간 " + (d.toMinutes() % 60) + "분";
    }

    private String getStatus(Object in) {
        LocalTime t = toTime(in);
        if (t == null) return "결근";
        return t.isAfter(LocalTime.of(9, 0)) ? "지각" : "출근";
    }

    private LocalTime toTime(Object t) {
        if (t instanceof LocalTime) return (LocalTime) t;
        if (t instanceof java.sql.Time) return ((java.sql.Time) t).toLocalTime();
        if (t instanceof String) try { return LocalTime.parse((String) t); } catch (Exception e) {}
        return null;
    }

    private void writeCell(Row row, int col, String val, CellStyle style) {
        Cell c = row.createCell(col);
        c.setCellValue(val);
        c.setCellStyle(style);
    }

    private CellStyle createHeaderStyle(Workbook wb) {
        CellStyle s = wb.createCellStyle();
        s.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
        s.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        s.setBorderTop(BorderStyle.THIN);
        s.setBorderBottom(BorderStyle.THIN);
        s.setBorderLeft(BorderStyle.THIN);
        s.setBorderRight(BorderStyle.THIN);
        s.setAlignment(HorizontalAlignment.CENTER);
        Font f = wb.createFont();
        f.setBold(true);
        f.setColor(IndexedColors.WHITE.getIndex());
        s.setFont(f);
        return s;
    }

    private CellStyle createDataStyle(Workbook wb) {
        CellStyle s = wb.createCellStyle();
        s.setBorderTop(BorderStyle.THIN);
        s.setBorderBottom(BorderStyle.THIN);
        s.setBorderLeft(BorderStyle.THIN);
        s.setBorderRight(BorderStyle.THIN);
        s.setAlignment(HorizontalAlignment.CENTER);
        return s;
    }

    private CellStyle createTitleStyle(Workbook wb) {
        CellStyle s = wb.createCellStyle();
        Font f = wb.createFont();
        f.setBold(true);
        f.setFontHeightInPoints((short) 16);
        s.setFont(f);
        s.setAlignment(HorizontalAlignment.CENTER);
        return s;
    }
} 
