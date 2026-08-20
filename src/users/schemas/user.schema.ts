import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type UserDocument = HydratedDocument<User>;

@Schema({ timestamps: true })
export class User {
  @Prop({ required: true })
  fullName: string;

  @Prop({ required: true })
  birthDate: Date;


  @Prop({ required: true, enum: ['ذكر', 'أنثى'] })
  gender: string;
  // ✅ التعديل: التخزين بالعربي
  @Prop({ required: true, enum: ['أمي','ابتدائي', 'إعدادي', 'ثانوي', 'جامعي'] })
  studyLevel: string;

  @Prop()
  specialty?: string; // اختصاص جامعي

  @Prop()
  secondaryTrack?: string; // علمي / أدبي

  // ✅ التعديل: التخزين بالعربي
  @Prop({ required: true, enum: ['لا أعمل', 'لدي عمل'] })
  workStatus: string;

  @Prop()
  workType?: string;

  @Prop({ required: true })
  address: string;

  @Prop({ required: true, unique: true })
  phone: string;

  @Prop({ required: true })
  password: string;

  // ✅ إضافة حقل الرقم التسلسلي (سيتم توليده تلقائياً)
  @Prop({ required: true, unique: true })
  sequentialNumber: number;
}

export const UserSchema = SchemaFactory.createForClass(User);