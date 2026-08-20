import { Type } from 'class-transformer';
import { IsInt, Min } from 'class-validator';

export class CreateAttendanceDto {
  @Type(() => Number)
  @IsInt()
  @Min(1)
  sequentialNumber: number;
}
