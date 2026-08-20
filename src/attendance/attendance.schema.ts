import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type AttendanceDocument = HydratedDocument<Attendance>;

@Schema({ timestamps: true })
export class Attendance {
  @Prop({ required: true, index: true })
  sequentialNumber!: number;

  @Prop({ required: true, default: Date.now })
  attendanceDate!: Date;

  @Prop({ required: true })
  attendanceDay!: string;
}

export const AttendanceSchema = SchemaFactory.createForClass(Attendance);
AttendanceSchema.index({ sequentialNumber: 1, attendanceDay: 1 }, { unique: true });
