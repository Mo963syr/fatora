import { IsString, IsDateString, IsIn, IsOptional, IsNotEmpty } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @IsNotEmpty()
  fullName: string;

  @IsDateString()
  @IsNotEmpty()
  birthDate: string;

  @IsIn(['أمي','ابتدائي', 'إعدادي', 'ثانوي', 'جامعي']) // ✅ تحديث القيم
  studyLevel: string;

  @IsOptional()
  @IsString()
  specialty?: string;

  @IsOptional()
  @IsString()
  secondaryTrack?: string;

  @IsIn(['لا أعمل', 'لدي عمل']) // ✅ تحديث القيم
  workStatus: string;

  @IsOptional()
  @IsString()
  workType?: string;

  @IsString()
  @IsNotEmpty()
  address: string;

  @IsString()
  @IsNotEmpty()
  phone: string;
}