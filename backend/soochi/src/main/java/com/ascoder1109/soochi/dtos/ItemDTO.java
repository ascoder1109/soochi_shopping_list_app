package com.ascoder1109.soochi.dtos;

import lombok.Data;

@Data
public class ItemDTO {

    private Long id;
    private String name;
    private String quantity;
    private boolean isChecked;

}
