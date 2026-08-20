import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class LoginUserDto {
  @Type(() => Number)
  @IsInt()
  @Min(1)
  sequentialNumber: number;

  @IsString()
  @IsNotEmpty()
  password: string;
}
