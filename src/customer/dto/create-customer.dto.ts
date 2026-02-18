import { IsString, IsNotEmpty, IsNumber } from 'class-validator';

export class CreateCustomerDto {
  @IsString()
  @IsNotEmpty()
  fullName: string;

  @IsString()
  @IsNotEmpty()
  phone: string;

  @IsString()
  @IsNotEmpty()
  address: string;

  @IsNumber()
  parcelsCount: number;
}
