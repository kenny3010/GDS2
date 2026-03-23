// Legend of Zelda Main Theme
// Outputs a PWM signal to drive a piezo buzzer or speaker
// Assumes 50MHz system clock

module zelda_theme (
    input  clk,        // 50 MHz system clock
    input  rst,        // Active high reset
    output wire speaker   // PWM output to piezo buzzer
);

// ============================================================
// Clock frequency
// ============================================================
parameter CLK_FREQ = 50_000_000;

// ============================================================
// Note frequency dividers (CLK_FREQ / note_freq / 2)
// ============================================================
parameter PAUSE = 32'd0;

parameter A4    = CLK_FREQ/ 2 / 440;
parameter G4    = CLK_FREQ/ 2 / 392;
parameter E4    = CLK_FREQ/ 2 / 330;
parameter B4    = CLK_FREQ/ 2 / 394;
parameter C5_S  = CLK_FREQ/ 2 / 554;
parameter D5    = CLK_FREQ/ 2 / 587;
parameter D5_S  = CLK_FREQ/ 2 / 622;
parameter E5    = CLK_FREQ/ 2 / 659;
parameter F5    = CLK_FREQ/ 2 / 698;
parameter F5_S  = CLK_FREQ/ 2 / 740;
parameter G5    = CLK_FREQ/ 2 / 784;
parameter G5_S  = CLK_FREQ/ 2 / 831;
parameter A5    = CLK_FREQ/ 2 / 880;
parameter B5    = CLK_FREQ/ 2 / 988;
parameter C6    = CLK_FREQ/ 2 / 1047;


// ============================================================
// Note durations (in clock cycles)
// Tempo ~120 BPM → quarter note = 0.5s = 25_000_000 cycles
// ============================================================
parameter TEMPO      = CLK_FREQ / 2;          // quarter note
parameter Q  = TEMPO;                          // quarter
parameter H  = TEMPO * 2;                      // half
parameter E  = TEMPO / 2;                      // eighth
parameter DQ = TEMPO + TEMPO / 2;             // dotted quarter
parameter T = TEMPO/3;                      // Triole
parameter T2 = TEMPO/3*2;
parameter DH = TEMPO*2+TEMPO;
parameter DE = TEMPO/2+TEMPO/4;

// ============================================================
// Song ROM — {note_divider, duration}
// ============================================================
parameter NOTE_COUNT = 64;

reg [31:0] note  [0:NOTE_COUNT-1];
reg [31:0] dur   [0:NOTE_COUNT-1];

integer i;
initial begin
    //1. Takt
    note[0]=A4;  dur[0]=H;
    note[1]=PAUSE;  dur[1]=T2;
    note[2]=A4;  dur[2]=T;
    note[3]=A4;  dur[3]=T;
    note[4]=A4;  dur[4]=T;
    note[5]=A4;  dur[5]=T;


    //2.Takt
    note[6]=A4;  dur[6]=T2;
    note[7]=G4;  dur[7]=T;
    note[8] =A4; dur[8] =Q;
    note[9] =PAUSE; dur[9] =T2;
    note[10]=A4; dur[10]=T;
    note[11]=A4; dur[11]=T;
    note[12]=A4; dur[12]=T;
    note[13]=A4; dur[13]=T;

    //3.Takt
    note[14]=A4; dur[14]=T2;
    note[15]=G4; dur[15]=T;
    note[16]=A4; dur[16]=Q;
    note[17]=PAUSE; dur[17]=T2;
    note[18]=A4; dur[18]=T;
    note[19]=A4; dur[19]=T;
    note[20]=A4; dur[20]=T;
    note[21]=A4; dur[21]=T;

    //4.Takt
    note[22]=A4; dur[22]=E;
    note[23]=E4; dur[23]=S;
    note[24]=E4; dur[24]=S;
    note[25]=E4; dur[25]=E;
    note[26]=E4; dur[26]=S;
    note[27]=E4; dur[27]=S;
    note[28]=E4; dur[28]=E;
    note[29]=E4; dur[29]=S;
    note[30]=E4; dur[30]=S;
    note[31]=E4; dur[31]=E;
    note[32]=E4; dur[32]=E;


    //5.Takt
    note[33]=A4; dur[33]=Q;
    note[34]=E4; dur[34]=DQ;
    note[35]=A4; dur[35]=E;
    note[36]=A4; dur[36]=S;
    note[37]=B4; dur[37]=S;
    note[38]=C5_S; dur[38]=S;
    note[39]=D5; dur[39]=S;

    //6.Takt
    note[40]=E5; dur[40]=H;
    note[41]=PAUSE; dur[41]=E;
    note[42]=E5; dur[42]=E;
    note[43]=E5; dur[43]=T;
    note[44]=F5; dur[44]=T;
    note[45]=G5; dur[45]=T;

    //7.Takt

    note[46]=A5; dur[46]=H;
    note[47]=PAUSE; dur[47]=E;
    note[48]=A5; dur[48]=E;
    note[49]=A5; dur[49]=T;
    note[50]=G5; dur[50]=T;
    note[51]=F5; dur[51]=T;

    //8.Takt

    note[52]=G5; dur[52]=DE;
    note[53]=F5; dur[53]=S;
    note[54]=E5; dur[54]=H;
    note[55]=E5;dur[55]=Q;

    //9.Takt

    note[56]=D5; dur[56]=E;
    note[57]=D5; dur[57]=S;
    note[58]=E5; dur[58]=S;
    note[59]=F5;dur[59]=H;
    note[60]=E4; dur[60]=E;
    note[61]=D5;dur[61]=E;


    //10.Takt
    note[62]=C5;dur[62]=E;
    note[63]=C5;dur[63]=S;
    note[64]=D5;dur[64]=S;
    note[65]=E5;dur[65]=H;
    note[66]=D5;dur[66]=E;
    note[67]=D5;dur[67]=E;

    //11.Takt

    note[68]=B4;dur[68]=E;
    note[69]=B4;dur[69]=S;
    note[70]=C5_S; dur[70]=S;
    note[71]=D5_S;dur[71]=H;
    note[72]=F5_S;dur[72]=Q;

    //12.Takt

    note[73]=E5;dur[73]=E;
    note[74]=E4;dur[74]=S;
    note[75]=E4;dur[75]=S;
    note[76]=E4;dur[76]=E;
    note[77]=E4;dur[77]=S;
    note[78]=E4;dur[78]=S;
    note[79]=E4;dur[79]=E;
    note[80]=E4; dur[80]=S;
    note[81]=E4;dur[81]=S;
    note[82]=E4;dur[82]=E;
    note[83]=E4;dur[83]=E;


    //13.Takt
    note[84]=A4;dur[84]=Q;
    note[85]=E4;dur[85]=DQ;
    note[86]=A4;dur[86]=E;
    note[87]=A4;dur[87]=S;
    note[88]=B4;dur[88]=S;
    note[89]=C5_S;dur[89]=S;
    note[90]=D5; dur[90]=S;


    //14.Takt
    note[91]=E5;dur[91]=H;
    note[92]=PAUSE;dur[92]=E;
    note[93]=E5;dur[93]=E;
    note[94]=E5;dur[94]=T;
    note[95]=F5;dur[95]=T;
    note[96]=G5;dur[96]=T;

    //15.Takt

    note[97]=A5;dur[97]=H;
    note[98]=PAUSE;dur[98]=Q;
    note[99]=C6;dur[99]=Q;

    //16.Takt

    note[100]=B5;dur[100]=Q;
    note[101]=G5_S;dur[101]=H;
    note[102]=E5;dur[102]=Q;

    //17.Takt
    note[103]=F5;dur[103]=DH;
    note[104]=A5;dur[104]=Q;

    //18.Takt
    note[105]=G5_S;dur[105]=Q;
    note[106]=E5;dur[106]=H;
    note[107]=E5;dur[107]=Q;

    //19.Takt
    note[108]=F5;dur[108]=DH;
    note[109]=A5;dur[109]=Q;

    //20.Takt
    note[110]=G5_S;dur[110]=H;
    note[111]=E5;dur[111]=Q;
    note[112]=C5_S;dur[112]=Q;

    //21.Takt
    note[113]=D5;dur[113]=DH;
    note[114]=F5;dur[114]=Q;

    //22.Takt
    note[115]=E5;dur[115]=Q;
    note[116]=C5;dur[116]=H;
    note[117]=A4;dur[117]=Q;

    //23.Takt
    note[118]=B4;dur[118]=E;
    note[119]=B4;dur[119]=S;
    note[120]=C5_S;dur[120]=S;
    note[121]=D5_S;dur[121]=H;
    note[122]=F5_S;dur[122]=Q;

    //24.Takt
    note[123]=E5;dur[123]=E;
    note[124]=E4;dur[124]=S;
    note[125]=E4;dur[125]=S;
    note[126]=E4;dur[126]=E;
    note[127]=E4;dur[127]=S;
    note[128]=E4;dur[128]=S;
    note[129]=E4;dur[129]=E;
    note[130]=E4;dur[130]=S;
    note[131]=E4;dur[131]=S;
    note[132]=E4;dur[132]=E;
    note[133]=E4;dur[133]=E;











end

// ============================================================
// Playback state machine
// ============================================================
reg [31:0] note_counter;   // counts up to note divider → toggles speaker
reg [31:0] dur_counter;    // counts up to duration → advances note
reg [6:0]  note_index;     // current note in ROM
reg        speaker_reg;

assign speaker = speaker_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        note_counter <= 32'd0;
        dur_counter  <= 32'd0;
        note_index   <= 7'd0;
        speaker_reg  <= 1'b0;
    end else begin

        // ---- Advance note when duration expires ----
        if (dur_counter >= dur[note_index] - 1) begin
            dur_counter  <= 32'd0;
            note_counter <= 32'd0;
            speaker_reg  <= 1'b0;
            // Loop song
            if (note_index >= NOTE_COUNT - 1)
                note_index <= 7'd0;
            else
                note_index <= 32'd33;
        end else begin
            dur_counter <= dur_counter + 1;

            // ---- Generate tone (skip toggle on REST) ----
            if (note[note_index] != REST) begin
                if (note_counter >= note[note_index] - 1) begin
                    note_counter <= 32'd0;
                    speaker_reg  <= ~speaker_reg;
                end else begin
                    note_counter <= note_counter + 1;
                end
            end else begin
                speaker_reg  <= 1'b0;
                note_counter <= 32'd0;
            end
        end
    end
end

endmodule

