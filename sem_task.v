//  ------------------------------------------------------------------------
// File :                       sem_task.v
// Author :                     superboy
// Created date :               2022/09/10
// Abstract     :               Unique module for record and tell the core what to do next. It will be designed upon the specific application scenarios.
// Last modified date :         2022/09/15
// -------------------------------------------------------------------
// -------------------------------------------------------------------
`include "sem_config.v"
module hsem_task
    (
        hclk,
        hresetn,
        wr_en,
        ihwdata,
        task_en,
        tsk_stat
    );
    input   hclk;
    input   hresetn;
    input   wr_en;
    input   [`AHB_DATA_WIDTH-1:0]   ihwdata;
    input   task_en;
    output  [`TASK_SWITCH_WIDTH-1:0]    tsk_stat;

    reg     [`TASK_SWITCH_WIDTH-1:0]    task_status;

    assign tsk_stat = task_status;

    always@(posedge hclk or negedge hresetn)
        begin : task_status_proc
            if(hresetn == 1'b0)
                begin
                    task_status <= 32'b0;
                end
            else if(task_en && wr_en)
                begin
                    task_status <= ihwdata;
                end
        end
endmodule